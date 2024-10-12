import mongoose from 'mongoose';

const { Schema } = mongoose;

const BudgetHistorySchema = new Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    oldMaximumAmount: { type: Number, required: true },
    newMaximumAmount: { type: Number, required: true },
    changeDate: { type: Date, default: Date.now },
    reason: { type: String, required: true }, 
});

const BudgetHistory = mongoose.model('BudgetHistory', BudgetHistorySchema);

export default BudgetHistory;
