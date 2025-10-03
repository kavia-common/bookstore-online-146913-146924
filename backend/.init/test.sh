#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/bookstore-online-146913-146924/backend"
cd "$WORKSPACE"
mkdir -p __tests__
cat > __tests__/api.test.js <<'J'
const request = require('supertest');
const app = require('../index');
test('GET /catalog returns 200 and array', async ()=>{
  const res = await request(app).get('/catalog');
  expect(res.statusCode).toBe(200);
  expect(Array.isArray(res.body)).toBe(true);
});
J
# ensure local jest binary exists and run it explicitly
if [ -x node_modules/.bin/jest ]; then
  node_modules/.bin/jest --runInBand
else
  echo "local jest not found; ensure devDependencies installed" >&2
  exit 6
fi
