import express from 'express';
import bcrypt from 'bcrypt';
import User from './../model/auth.js';
import { sendVerificationCode } from '../services/mailService.js';
import crypto from 'crypto';
import jwt from 'jsonwebtoken';

const router = express.Router();

// Temporary storage for verification codes
const verificationCodes = {};

// Forgot Password - Request Code
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

// Verify Code and Reset Password
router.post('/reset-password', async (req, res) => {
    const { email, code, newPassword } = req.body;

    // Input validation
    if (!email || !code || !newPassword) {
        return res.status(400).json({
            status: "Failed",
            message: "All fields are required."
        });
    }

    try {
        // Check if the code is correct
        if (verificationCodes[email] !== code) {
            return res.status(400).json({
                status: "Failed",
                message: "Invalid or expired code."
            });
        }

        // Find user and update password
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({
                status: "Failed",
                message: "User not found."
            });
        }

        // Hash new password
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(newPassword, saltRounds);
        user.password = hashedPassword;
        await user.save();

        // Remove code after successful reset
        delete verificationCodes[email];

        return res.status(200).json({
            status: "Success",
            message: "Password reset successful."
        });
    } catch (error) {
        console.error(error); // Log the error for debugging
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while resetting the password."
        });
    }
});

router.post('/signup', async (req, res) => {
    let { firstName, middleName, lastName, email, dateOfBirth, phone, password } = req.body;

    console.log(req.body);

    // Check if any fields are undefined or empty
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

    // Trim input fields only if they exist
    firstName = firstName.trim();
    middleName = middleName.trim();
    lastName = lastName.trim();
    email = email.trim();
    dateOfBirth = dateOfBirth.trim();
    phone = phone.trim();
    password = password.trim();

    // Name validation
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

    // Date of Birth validation
    const parsedDate = new Date(dateOfBirth); 
    if (isNaN(parsedDate.getTime())) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid date of birth entered!"
        });
    }


    // Email validation
    if (!/^[\w-.]+@([\w-]+\.)+[a-zA-Z]{2,7}$/.test(email)) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid email format!"
        });
    }

    // Phone validation (adjust regex as needed)
    if (!/^\d{10}$/.test(phone)) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid phone number format! Must be 10 digits."
        });
    }

    // Password validation
    if (password.length < 8) {
        return res.status(400).json({
            status: "Failed",
            message: "Password must be at least 8 characters long."
        });
    }

    try {
        // Check if user already exists
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({
                status: "Failed",
                message: "User with the provided email already exists."
            });
        }

        // Hash password
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        // Create new user
        const newUser = new User({
            firstName,
            middleName,
            lastName,
            email,
            dateOfBirth: parsedDate,
            phone,
            password: hashedPassword,
            verified: false,
        });
        
        // Save user
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
  
      const isPasswordValid = await bcrypt.compare(password, user.password);
  
      if (!isPasswordValid) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }
  
      // Instead of a token, simply send back the user ID
      res.json({ userId: user._id, message: 'Login successful' });
    } catch (error) {
      res.status(500).json({ message: 'Internal server error' });
    }
  });
export default router;
