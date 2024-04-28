import { describe, test, expect, beforeAll } from "@jest/globals"
import request, { Response } from 'supertest';

let baseUrl: string;
let response: Response;

beforeAll(() => {
  baseUrl = process.env.BASE_URL || "";
});

describe('GET /api/task', () =>{
  test('is 200', async () =>{
    response = await request(baseUrl)
      .get('/api/task')
      .send({})
      .set('Content-Type', 'application/json');
    expect(response.status).toBe(200);
  })
})