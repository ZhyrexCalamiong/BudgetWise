import dotenv from 'dotenv';
import mongoose from 'mongoose';

dotenv.config();

const MONGO_URL = process.env.MONGO_URL;

mongoose
    .connect(MONGO_URL)
    .then(() => {
        console.log("Database is connected successfully.");
    })
    .catch((error) => console.log(error));
