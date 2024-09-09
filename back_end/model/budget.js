import mongoose from 'mongoose';

const { Schema } = mongoose;

const BudgetSchema = new Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    maximumAmount: { type: Number, required: true },
    amountSpent: { type: Number, default: 0 },
});

const Budget = mongoose.model('Budget', BudgetSchema);

export default Budget;
