import { DBClient } from './db/db.client';
import { Request, Response } from 'express';
import { APIResponse } from './types/api.response';
import { v4 as uuidv4 } from 'uuid';

const putTask = async (req: Request, res: Response) => {
    const client = new DBClient();

    const newUuid = uuidv4();
    const { title, description } = req.body;

    if (title === null || title === undefined) {
        return res.status(400).json({ error: "Title is required" });
    }

    let response: APIResponse;
    const task: Record<string, any> = {
        id: newUuid,
        title: title,
        description: description,
        completed: false
    }
    response = await client.put(task);

    client.close();

    return res.status(response.code).json(response.body);
}

const getTask = async (req: Request, res: Response) => {
    const client = new DBClient();

    let response: APIResponse;

    response = await client.get({});

    client.close();

    return res.status(response.code).json(response.body);
}

export default {
    putTask,
    getTask
};
