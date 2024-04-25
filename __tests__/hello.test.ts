import { describe, test, expect, beforeAll } from "@jest/globals"
import request, { Response } from 'supertest';

let baseUrl: string;
let response: Response;

beforeAll(() => {
  baseUrl = process.env.BASE_URL || "";
});

describe('/hello', () =>{
  test('is 200', async () =>{
    response = await request(baseUrl).get('/hello');
    expect(response.status).toBe(203);
  })
})