import express from 'express';
import axios from 'axios';
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

const convert = express.Router();
convert.use(express.json());

// Route for currency conversion
convert.get('/convert', async (req, res) => {
    const { from, to, amount } = req.query;

    // Validate input
    if (!from || !to || !amount || isNaN(amount)) {
        return res.status(400).json({ message: 'Invalid input. Please provide "from", "to", and "amount" query parameters.' });
    }

    try {
        // Fetch exchange rates from API
        const response = await axios.get(`https://v6.exchangerate-api.com/v6/${process.env.EXCHANGE_RATE_API_KEY}/latest/${from}`);

        const exchangeRate = response.data.conversion_rates[to];

        if (!exchangeRate) {
            return res.status(404).json({ message: `Unable to find exchange rate from ${from} to ${to}.` });
        }

        // Calculate the converted amount
        const convertedAmount = (amount * exchangeRate).toFixed(2);

        return res.status(200).json({
            from,
            to,
            amount,
            convertedAmount,
            rate: exchangeRate
        });

    } catch (error) {
        console.error('Error fetching exchange rate:', error.message);
        return res.status(500).json({ message: 'Error fetching exchange rate.' });
    }
});

export default convert;
