const express = require('express');
const r = express.Router();
r.get('/', (req,res)=> res.json([{id:1,title:'Sample Book'}]));
module.exports = r;
