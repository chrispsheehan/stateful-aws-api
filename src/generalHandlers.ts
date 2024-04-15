import { DBClient } from './db/db.client';
import { Request, Response } from 'express';
import { APIResponse } from './types/api.response';
import { v4 as uuidv4 } from 'uuid';

function getIp(req: Request, res: Response) {
    const client = new DBClient();
    
    const ip: string = (req.headers['x-forwarded-for'] || req.socket.remoteAddress || "").toString()
    const newUuid = uuidv4();

    let response: APIResponse;
    client.put({
        id: newUuid,
        timestamp: new Date().toISOString(),
        ip: ip
    })
    .then(resp => {
        response = resp;
    })
    .finally(() => {
        client.close();
    })

    return res.status(response.statusCode).json(response.body);
}

export default {
    getIp
};