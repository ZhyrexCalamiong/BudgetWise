import express from 'express';
import User from './../model/auth.js';
import Budget from './../model/budget.js';
import Expense from './../model/expenses.js';

const budget = express.Router();

// Set or Update Budget for a user
budget.post('/set-budget', async (req, res) => {
    const { userId, maximumAmount } = req.body;

    if (!userId || !maximumAmount) {
        return res.status(400).json({
            status: "Failed",
            message: "User ID and maximum amount are required."
        });
    }

    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                status: "Failed",
                message: "User not found."
            });
        }

        let budget = await Budget.findOne({ user: userId });

        if (budget) {
            budget.maximumAmount = maximumAmount;
            budget.amountSpent = 0; // Reset amount spent
        } else {
            budget = new Budget({
                user: userId,
                maximumAmount,
                amountSpent: 0
            });
        }

        const result = await budget.save();

        return res.status(201).json({
            status: "Success",
            message: "Budget set successfully.",
            data: result,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while setting the budget."
        });
    }
});

// Add an expense for a user
budget.post('/add-expense', async (req, res) => {
    const { userId, cost, description, date } = req.body;

    if (!userId || !cost || !description || !date) {
        return res.status(400).json({
            status: "Failed",
            message: "All fields are required."
        });
    }

    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                status: "Failed",
                message: "User not found."
            });
        }

        const budget = await Budget.findOne({ user: userId });

        if (!budget) {
            return res.status(404).json({
                status: "Failed",
                message: "Budget not found."
            });
        }

        // Check if the cost exceeds the remaining budget
        const remainingBudget = budget.maximumAmount - budget.amountSpent;
        if (cost > remainingBudget) {
            return res.status(400).json({
                status: "Failed",
                message: "Expense exceeds the remaining budget."
            });
        }

        // Update the maximumAmount by subtracting the expense amount
        budget.maximumAmount -= cost;
        budget.amountSpent += cost;
        await budget.save();

        // Create a new expense
        const expense = new Expense({
            user: userId,
            cost,
            description,
            date: new Date(date),
            amountSpent: budget.amountSpent // Log the updated amountSpent
        });

        const result = await expense.save();

        return res.status(201).json({
            status: "Success",
            message: "Expense added successfully.",
            data: result,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while adding the expense."
        });
    }
});

// Get all expenses for a user
budget.get('/user-expenses/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const expenses = await Expense.find({ user: userId }).populate('user', 'name email');
        if (!expenses || expenses.length === 0) {
            return res.status(404).json({
                status: "Failed",
                message: "No expenses found for this user."
            });
        }

        return res.status(200).json({
            status: "Success",
            data: expenses,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while retrieving expenses."
        });
    }
});

// Get the budget details including total spent and remaining budget
budget.get('/budget/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const budget = await Budget.findOne({ user: userId });
        if (!budget) {
            return res.status(404).json({
                status: "Failed",
                message: "Budget not found."
            });
        }

        const remainingBudget = budget.maximumAmount - budget.amountSpent;

        return res.status(200).json({
            status: "Success",
            data: {
                maximumAmount: budget.maximumAmount,
                amountSpent: budget.amountSpent,
                remainingBudget: remainingBudget
            },
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while retrieving the budget."
        });
    }
});

export default budget;
