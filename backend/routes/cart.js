const express = require('express');
const r = express.Router();
let cart = [];
r.get('/', (req,res)=> res.json(cart));
r.post('/', (req,res)=> { cart.push(req.body); res.status(201).json(req.body); });
module.exports = r;
