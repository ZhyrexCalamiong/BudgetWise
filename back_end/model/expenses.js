import mongoose from 'mongoose';

const { Schema } = mongoose;

const ExpenseSchema = new Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    cost: { type: Number, required: true },
    description: { type: String, required: true },
    date: { type: Date, required: true },
});

const Expense = mongoose.model('Expense', ExpenseSchema);

export default Expense;
