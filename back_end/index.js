import './config/db.js';
import express from 'express';
import router from './api/routes.js';
import budget from './api/budgetroutes.js';
import convert from './api/moneyconvert.js';
import cors from 'cors';

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true })); 


app.use('/api', router);
app.use('/api', budget);
app.use('/api', convert);



app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
