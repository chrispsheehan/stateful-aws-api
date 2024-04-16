import { DBClient } from './db/db.client';
import { Request, Response } from 'express';
import { APIResponse } from './types/api.response';
import { v4 as uuidv4 } from 'uuid';

async function putTask(req: Request, res: Response) {
    const client = new DBClient();
    const newUuid = uuidv4();

    let response: APIResponse;
    const task: Record<string, any> = {
        id: newUuid,
        title: "test",
        description: "test badger badgers description",
        completed: false
    }
    response = await client.put(task);

    client.close();

    return res.status(response.code).json(response.body);
}

export default {
    putTask
};