import express from 'express';
import User from './../model/auth.js';
import Budget from './../model/budget.js';
import Expense from './../model/expenses.js';
import BudgetHistory from './../model/busget_history.js';
import ExpenseHistory from './../model/expnses_history.js';


const budget = express.Router();

// Set or Update Budget for a user
budget.post('/set-budget', async (req, res) => {
    const { userId, maximumAmount } = req.body;

    if (!userId || !maximumAmount) {
        return res.status(400).json({
            status: "Failed",
            message: "User ID and maximum amount are required."
        });
    }

    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                status: "Failed",
                message: "User not found."
            });
        }

        let budget = await Budget.findOne({ user: userId });

        if (budget) {
            // Record the old maximumAmount for history
            const oldMaximumAmount = budget.maximumAmount;

            // Update the maximumAmount
            budget.maximumAmount += maximumAmount;

            // Create a new history record
            const budgetHistory = new BudgetHistory({
                user: userId,
                oldMaximumAmount: oldMaximumAmount,
                newMaximumAmount: budget.maximumAmount,
                reason: "Updated budget amount", // Customize this message as needed
                date: new Date() // Set the current date
            });

            await budgetHistory.save(); // Save the budget history
        } else {
            budget = new Budget({
                user: userId,
                maximumAmount,
                amountSpent: 0 // This will still be 0 for a new budget
            });
        }

        const result = await budget.save();

        return res.status(201).json({
            status: "Success",
            message: "Budget set successfully.",
            data: result,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while setting the budget."
        });
    }
});


budget.post('/add-expense', async (req, res) => {
    const { userId, cost, description, date } = req.body;

    // Validate input
    if (!userId || !cost || !description || !date) {
        return res.status(400).json({
            status: "Failed",
            message: "All fields are required."
        });
    }

    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                status: "Failed",
                message: "User not found."
            });
        }

        const budget = await Budget.findOne({ user: userId });
        if (!budget) {
            return res.status(404).json({
                status: "Failed",
                message: "Budget not found."
            });
        }

        // Calculate remaining budget
        const remainingBudget = budget.maximumAmount - budget.cost;

        // Prevent adding expense if it would make the maximum amount negative
        if (remainingBudget < cost) {
            return res.status(400).json({
                status: "Failed",
                message: "Expense exceeds the available budget."
            });
        }

        // Update the amountSpent and maximumAmount
        budget.amountSpent += cost;
        budget.maximumAmount -= cost;

        // Ensure maximumAmount does not go below zero
        if (budget.maximumAmount < 0) {
            return res.status(400).json({
                status: "Failed",
                message: "Expense exceeds the available budget."
            });
        }

        await budget.save();

        // Create a new expense entry
        const expense = new Expense({
            user: userId,
            cost,
            description,
            date: new Date(date), // Ensure the date is correctly parsed
        });

        const result = await expense.save();

        // Create a new history record for the added expense
        const expenseHistory = new ExpenseHistory({
            user: userId,
            expenseId: result._id,
            oldCost: 0,
            newCost: cost,
            oldDescription: '', // No previous description
            newDescription: description,
            reason: 'Added new expense',
        });

        await expenseHistory.save(); // Save the expense history

        return res.status(201).json({
            status: "Success",
            message: "Expense added successfully.",
            data: {
                expense: result,
                budget: {
                    maximumAmount: budget.maximumAmount,
                    amountSpent: budget.amountSpent,
                },
            },
        });
    } catch (error) {
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while adding the expense.",
            error: error.message,
        });
    }
});



budget.put('/edit-expense/:expenseId', async (req, res) => {
    const { expenseId } = req.params;
    const { userId, cost, description, date } = req.body;

    // Validate input
    if (!userId || !cost || !description || !date) {
        return res.status(400).json({
            status: "Failed",
            message: "All fields are required."
        });
    }

    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                status: "Failed",
                message: "User not found."
            });
        }

        const expense = await Expense.findById(expenseId);
        if (!expense) {
            return res.status(404).json({
                status: "Failed",
                message: "Expense not found."
            });
        }

        // Save old values for history
        const oldCost = expense.cost;
        const oldDescription = expense.description;

        // Update expense details
        expense.cost = cost;
        expense.description = description;
        expense.date = new Date(date);

        await expense.save();

        // Create a new history record for the edited expense
        const expenseHistory = new ExpenseHistory({
            user: userId,
            expenseId: expenseId,
            oldCost: oldCost,
            newCost: cost,
            oldDescription: oldDescription,
            newDescription: description,
            reason: 'Edited expense details',
        });

        await expenseHistory.save(); // Save the expense history

        return res.status(200).json({
            status: "Success",
            message: "Expense updated successfully.",
            data: expense,
        });
    } catch (error) {
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while updating the expense.",
            error: error.message
        });
    }
});



// Get all expenses for a user
budget.get('/user-expenses/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const expenses = await Expense.find({ user: userId }).populate('user', 'name email');
        if (!expenses || expenses.length === 0) {
            return res.status(404).json({
                status: "Failed",
                message: "No expenses found for this user."
            });
        }

        return res.status(200).json({
            status: "Success",
            data: expenses,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while retrieving expenses."
        });
    }
});

// Get the budget details including total spent and remaining budget
budget.get('/budget/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const budget = await Budget.findOne({ user: userId });
        if (!budget) {
            return res.status(404).json({
                status: "Failed",
                message: "Budget not found."
            });
        }

        return res.status(200).json({
            status: "Success",
            data: {
                maximumAmount: budget.maximumAmount,
                amountSpent: budget.amountSpent,
            },
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while retrieving the budget."
        });
    }
});

budget.get('/user-budget/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const budget = await Budget.findOne({ user: userId });

        if (!budget) {
            return res.status(404).json({
                status: "Failed",
                message: "Budget not found for this user."
            });
        }

        return res.status(200).json({
            status: "Success",
            data: {
                maximumAmount: budget.maximumAmount,
                amountSpent: budget.amountSpent,
            },
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while retrieving budget details."
        });
    }
});

budget.get('/user-budget-history/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        // Fetch the budget history for the user
        const budgetHistory = await BudgetHistory.find({ user: userId });

        if (!budgetHistory || budgetHistory.length === 0) {
            return res.status(404).json({
                status: "Failed",
                message: "No budget history found for this user."
            });
        }

        return res.status(200).json({
            status: "Success",
            data: budgetHistory.map(history => ({
                oldMaximumAmount: history.oldMaximumAmount,
                newMaximumAmount: history.newMaximumAmount,
                changeDate: history.changeDate,
                reason: history.reason
            }))
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: "Failed",
            message: "An error occurred while retrieving the budget history."
        });
    }
});






export default budget;
