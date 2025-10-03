const request = require('supertest');
const app = require('../index');
test('GET /catalog returns 200 and array', async ()=>{
  const res = await request(app).get('/catalog');
  expect(res.statusCode).toBe(200);
  expect(Array.isArray(res.body)).toBe(true);
});
