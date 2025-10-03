#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/bookstore-online-146913-146924/backend"
mkdir -p "$WORKSPACE" && cd "$WORKSPACE"
PKG=package.json
OUT="$PKG"
if [ -f "$PKG" ]; then OUT="$PKG.generated"; fi
cat > "$OUT" <<'JSON'
{
  "name": "bookstore-backend",
  "version": "0.1.0",
  "private": true,
  "main": "index.js",
  "scripts": {
    "start": "node start.js",
    "start-dev": "nodemon start.js",
    "test": "jest --runInBand"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "dotenv": "^16.0.0",
    "jest": "^29.0.0",
    "nodemon": "^2.0.0",
    "supertest": "^6.3.0"
  }
}
JSON
# index.js: export app; guard dotenv load so production installs without dotenv don't crash
if [ -f index.js ]; then cp index.js index.js.generated; else
cat > index.js <<'JS'
const express = require('express');
try { require('dotenv').config(); } catch (e) { /* dotenv optional at runtime */ }
const app = express();
app.use(express.json());
app.use('/catalog', require('./routes/catalog'));
app.use('/cart', require('./routes/cart'));
app.use('/checkout', require('./routes/checkout'));
module.exports = app;
JS
fi
# start.js: starts the app when invoked
if [ -f start.js ]; then cp start.js start.js.generated; else
cat > start.js <<'S'
const app = require('./index');
const port = process.env.PORT || 3000;
const server = app.listen(port, ()=> console.log('listening '+port));
module.exports = server;
S
fi
mkdir -p routes
if [ ! -f routes/catalog.js ]; then
cat > routes/catalog.js <<'R'
const express = require('express');
const r = express.Router();
r.get('/', (req,res)=> res.json([{id:1,title:'Sample Book'}]));
module.exports = r;
R
fi
if [ ! -f routes/cart.js ]; then
cat > routes/cart.js <<'R'
const express = require('express');
const r = express.Router();
let cart = [];
r.get('/', (req,res)=> res.json(cart));
r.post('/', (req,res)=> { cart.push(req.body); res.status(201).json(req.body); });
module.exports = r;
R
fi
if [ ! -f routes/checkout.js ]; then
cat > routes/checkout.js <<'R'
const express = require('express');
const r = express.Router();
r.post('/', (req,res)=> res.json({status:'ok'}));
module.exports = r;
R
fi
if [ ! -f .env ]; then
  cat > .env <<'E'
PORT=3000
NODE_ENV=development
E
fi
if [ ! -f .gitignore ]; then
  cat > .gitignore <<'G'
node_modules/
.env
npm-debug.log
.DS_Store
G
fi
# README: instruct 'npm i' by default and note npm ci requires lockfile
if [ ! -f README.md ]; then
  cat > README.md <<'M'
# Bookstore Backend

Run (inside container workspace):
  npm i
  npm start
Dev: npm run start-dev (requires nodemon/devDependencies)
Test: npm test
Note: dotenv is a devDependency; development installs include it. 'npm ci' can be used if package-lock.json is present.
M
fi
# create a package-lock.json so npm ci can be used later reproducibly
if [ -f package.json ] && [ ! -f package-lock.json ]; then
  npm i --package-lock-only --no-audit --no-fund >/dev/null
fi
