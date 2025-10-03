const express = require('express');
try { require('dotenv').config(); } catch (e) { /* dotenv optional at runtime */ }
const app = express();
app.use(express.json());
app.use('/catalog', require('./routes/catalog'));
app.use('/cart', require('./routes/cart'));
app.use('/checkout', require('./routes/checkout'));
module.exports = app;
