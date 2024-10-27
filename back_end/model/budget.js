import mongoose from 'mongoose';

const { Schema } = mongoose;

const BudgetSchema = new Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    maximumAmount: { type: Number, required: true },
    amountSpent: { type: Number, default: 0 },
    date: { type: Date, default: Date.now }
});

let Budget;

try {
    Budget = mongoose.model('Budget');
} catch (error) {
    Budget = mongoose.model('Budget', BudgetSchema);
}

export default Budget;
