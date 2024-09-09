import express from 'express';
import bcrypt from 'bcrypt';
import User from './../model/auth.js';
import { sendVerificationCode } from '../services/mailService.js';
import crypto from 'crypto';

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

    // Check if user exists
    const user = await User.findOne({ email });
    if (!user) {
        return res.status(404).json({
            status: "Failed",
            message: "User not found."
        });
    }

    // Generate a verification code
    const code = crypto.randomInt(100000, 999999).toString();
    verificationCodes[email] = code; // Store code temporarily

    // Send the code via email
    await sendVerificationCode(email, code);

    return res.status(200).json({
        status: "Success",
        message: "Verification code sent to your email."
    });
});

// Verify Code and Reset Password
router.post('/reset-password', async (req, res) => {
    const { email, code, newPassword } = req.body;

    if (!email || !code || !newPassword) {
        return res.status(400).json({
            status: "Failed",
            message: "All fields are required."
        });
    }

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
});

router.post('/signup', async (req, res) => {
    let { name, email, DateOfBirth, Phone, password } = req.body;

    // Trim input fields
    name = name.trim();
    email = email.trim();
    DateOfBirth = DateOfBirth.trim();
    Phone = Phone.trim();
    password = password.trim();

    // Validate fields
    if (!name || !email || !DateOfBirth || !Phone || !password) {
        return res.status(400).json({
            status: "Failed",
            message: "Empty input fields!"
        });
    }

    // Name validation
    if (!/^[a-zA-Z\s]+$/.test(name)) {
        return res.status(400).json({
            status: "Failed",
            message: "Invalid name entered!"
        });
    }

    // Date of Birth validation
    const parsedDate = new Date(DateOfBirth);
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
    if (!/^\d{10}$/.test(Phone)) {
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
            name,
            email,
            DateOfBirth: parsedDate, // Store as Date
            Phone,
            password: hashedPassword,
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
    let { emailOrPhone, password } = req.body;

    // Trim input fields
    emailOrPhone = emailOrPhone.trim();
    password = password.trim();

    // Validate fields
    if (!emailOrPhone || !password) {
        return res.status(400).json({
            status: "Failed",
            message: "Empty input fields!"
        });
    }

    // Check if user exists (by email or phone)
    let user;
    if (/\S+@\S+\.\S+/.test(emailOrPhone)) {
        // It's an email
        user = await User.findOne({ email: emailOrPhone });
    } else if (/^\d{10}$/.test(emailOrPhone)) {
        // It's a phone number
        user = await User.findOne({ Phone: emailOrPhone });
    }

    if (!user) {
        return res.status(401).json({
            status: "Failed",
            message: "User not found."
        });
    }

    // Compare passwords
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        return res.status(401).json({
            status: "Failed",
            message: "Invalid credentials."
        });
    }

    return res.status(200).json({
        status: "Success",
        message: "Signin successful",
        data: user,
    });
});

export default router;
