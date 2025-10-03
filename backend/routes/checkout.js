const express = require('express');
const r = express.Router();
r.post('/', (req,res)=> res.json({status:'ok'}));
module.exports = r;
