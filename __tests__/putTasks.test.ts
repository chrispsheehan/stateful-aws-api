import { describe, test, expect, beforeAll } from "@jest/globals"
import request, { Response } from 'supertest';

let baseUrl: string;
let response: Response;

beforeAll(() => {
  baseUrl = process.env.BASE_URL || "";
});

describe('PUT /api/task', () =>{
  test('is 400', async () =>{
    const newTask = {
      description: 'Example Description'
    };

    response = await request(baseUrl)
      .put('/api/task')
      .send(newTask)
      .set('Content-Type', 'application/json');
    console.log('test' + JSON.stringify(response));
    expect(response.status).toBe(400);
  })

  test('is 204', async () =>{
    const newTask = {
      title: 'testtxtx',
      description: 'Example Description'
    };

    response = await request(baseUrl)
      .put('/api/task')
      .send(newTask)
      .set('Content-Type', 'application/json');
    console.log('test' + JSON.stringify(response));
    expect(response.status).toBe(204);
  })
})