import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.GMAIL_USER,
        pass: process.env.GMAIL_PASS,
    },
});

export const sendVerificationCode = async (email, code) => {
    const mailOptions = {
        from: process.env.GMAIL_USER,
        to: email,
        subject: 'Password Reset Code',
        text: `Your password reset code is: ${code}`,
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log('Verification code sent.');
    } catch (error) {
        console.error('Error sending email:', error);
    }
};
