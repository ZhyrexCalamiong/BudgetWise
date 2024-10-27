import express from 'express';
import User from './../model/auth.js';
import Budget from '../model/Budget.js';
import { sendVerificationCode } from '../services/mailService.js';
import crypto from 'crypto';
import { generateToken, authenticateToken } from '../token/token.js';
import { createObjectCsvWriter } from 'csv-writer';
import fs from 'fs';
import path from 'path';

const router = express.Router();
const verificationCodes = {};

router.post('/forgot-password', async (req, res) => {
    const { email } = req.body;

    if (!email) {
        return res.status(400).json({
            status: "Failed",
            message: "Email is required."
        });
    }

    const user = await User.findOne({ email });
    if (!user) {
        return res.status(404).json({
            status: "Failed",
            message: "User not found."
        });
    }

    const code = crypto.randomInt(100000, 999999).toString();
    verificationCodes[email] = code; 

    await sendVerificationCode(email, code);

    return res.status(200).json({
        status: "Success",
        message: "Verification code sent to your email."
    });
});

router.post('/reset-password', async (req, res) => {
    const { email, code, newPassword } = req.body;

    if (!email || !code || !newPassword) {
        return res.status(400).json({
            status: "Failed",
            message: "All fields are required."
        });
    }

    try {
        if (verificationCodes[email] !== code) {
            return res.status(400).json({
                status: "Failed",
                message: "Invalid or expired code."
            });
        }

        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({
                status: "Failed",
                message: "User not found."
            });
        }

        user.password = newPassword;
        await user.save();

        delete verificationCodes[email];

        return res.status(200).json({
            status: "Success",
            message: "Password reset successful."
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while resetting the password."
        });
    }
});

router.post('/signup', async (req, res) => {
    let { firstName, middleName, lastName, email, dateOfBirth, phone, password } = req.body;

    console.log(req.body);

    if (!firstName || !middleName || !lastName || !email || !dateOfBirth || !phone || !password) {
        let missingFields = [];
        if (!firstName) missingFields.push("firstName");
        if (!middleName) missingFields.push("middleName");
        if (!lastName) missingFields.push("lastName");
        if (!email) missingFields.push("email");
        if (!dateOfBirth) missingFields.push("dateOfBirth");
        if (!phone) missingFields.push("phone");
        if (!password) missingFields.push("password");

        return res.status(400).json({
            status: "Failed",
            message: `Missing input fields: ${missingFields.join(', ')}`
        });
    }

    firstName = firstName.trim();
    middleName = middleName.trim();
    lastName = lastName.trim();
    email = email.trim();
    dateOfBirth = dateOfBirth.trim();
    phone = phone.trim();
    password = password.trim();

    if (!/^[a-zA-Z\s]+$/.test(firstName)) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid firstName entered!"
        });
    }
    if (!/^[a-zA-Z\s]+$/.test(middleName)) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid middleName entered!"
        });
    }
    if (!/^[a-zA-Z\s]+$/.test(lastName)) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid lastName entered!"
        });
    }

    const parsedDate = new Date(dateOfBirth); 
    if (isNaN(parsedDate.getTime())) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid date of birth entered!"
        });
    }

    if (!/^[\w-.]+@([\w-]+\.)+[a-zA-Z]{2,7}$/.test(email)) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid email format!"
        });
    }

    if (!/^\d{10}$/.test(phone)) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid phone number format! Must be 10 digits."
        });
    }

    if (password.length < 8) {
        return res.status(400).json({
            status: "Failed",
            message: "Password must be at least 8 characters long."
        });
    }

    try {
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({
                status: "Failed",
                message: "User with the provided email already exists."
            });
        }

        const newUser = new User({
            firstName,
            middleName,
            lastName,
            email,
            dateOfBirth: parsedDate,
            phone,
            password,
            verified: false,
        });
        
        const result = await newUser.save();
        return res.status(201).json({
            status: "Success",
            message: "Signup successful",
            data: result,
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred during the signup process."
        });
    }
});

router.post('/signin', async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        if (user.password !== password) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const token = generateToken(user);

        res.json({ userId: user._id, token, message: 'Login successful' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/user/:id', async (req, res) => {
    try {
        const userId = req.params.id;
        const user = await User.findById(userId, 'firstName middleName lastName');

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ message: 'Server error', error });
    }
});

router.put('/user/:id', async (req, res) => {
    const userId = req.params.id;
    const content = req.body;

    console.log("Received request to update user:", userId, content);

    const updateData = {};

    if (content.hasOwnProperty('firstName')) {
        updateData.firstName = content.firstName.trim() === '' ? null : content.firstName;
    }
    if (content.hasOwnProperty('middleName')) {
        updateData.middleName = content.middleName.trim() === '' ? null : content.middleName;
    }
    if (content.hasOwnProperty('lastName')) {
        updateData.lastName = content.lastName.trim() === '' ? null : content.lastName;
    }
    if (content.hasOwnProperty('phone')) {
        updateData.phone = content.phone.trim() === '' ? null : content.phone;
    }

    if (content.password) {
        updateData.password = content.password;
    }

    try {
        const user = await User.findOneAndUpdate(
            { _id: userId },
            { $set: updateData },
            { new: true, runValidators: true }
        );

        if (!user) {
            console.log("User not found.");
            return res.status(404).json({ message: `No record found with user ID ${userId}.` });
        }

        console.log("User updated successfully:", user);
        res.status(200).json({
            message: `Record of ${user.lastName}, ${user.firstName} has been updated.`,
            user
        });
    } catch (error) {
        console.error("Error updating user:", error);
        res.status(500).json({ message: "Database query error" });
    }
});

router.get('/export-csv', async (req, res) => {
    try {
        // Fetch budgets from the database, populating the user details
        const budgets = await Budget.find().populate('user', 'firstName lastName _id'); // Include user _id in the population

        // Map budgets to the required format for CSV
        const records = budgets.map(budget => ({
            budgetID: budget._id, // Include the MongoDB Budget document ID
            userID: budget.user._id, // Include the MongoDB User document ID
            userFirstName: budget.user.firstName, // User's first name
            userLastName: budget.user.lastName, // User's last name
            maximumAmount: budget.maximumAmount,
            amountSpent: budget.amountSpent,
            date: budget.date.toISOString().split('T')[0],
        }));

        // Define the CSV writer
        const csvFilePath = path.join(process.cwd(), 'budgets.csv');
        const csvWriter = createObjectCsvWriter({
            path: csvFilePath,
            header: [
                { id: 'budgetID', title: 'Budget ID' }, // Include Budget ID in the CSV header
                { id: 'userID', title: 'User ID' }, // Include User ID in the CSV header
                { id: 'userFirstName', title: 'User First Name' }, // User First Name in CSV
                { id: 'userLastName', title: 'User Last Name' }, // User Last Name in CSV
                { id: 'maximumAmount', title: 'Maximum Amount' },
                { id: 'amountSpent', title: 'Amount Spent' },
                { id: 'date', title: 'Date' },
            ],
        });

        // Write records to CSV
        await csvWriter.writeRecords(records);
        res.download(csvFilePath); // Send the CSV file for download
    } catch (error) {
        console.error('Error exporting CSV:', error); // Log the error details
        res.status(500).json({ message: 'An error occurred while exporting data to CSV.', error: error.message }); // Include error details in the response
    }
});

export default router;