import mongoose from 'mongoose';

const { Schema } = mongoose;

const ExpenseHistorySchema = new Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    expenseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Expense', required: true },
    oldCost: { type: Number, required: true },
    newCost: { type: Number, required: true },
    oldDescription: { type: String, required: true },
    newDescription: { type: String, required: true },
    changeDate: { type: Date, default: Date.now },
    reason: { type: String, required: true }, // Optional field to explain the change
});

const ExpenseHistory = mongoose.model('ExpenseHistory', ExpenseHistorySchema);

export default ExpenseHistory;
