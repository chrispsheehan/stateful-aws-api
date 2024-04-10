import { Request, Response } from 'express';
import { record } from './lib/db.editor';

function getIp(req: Request, res: Response): Response {
    const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress 
    record(ip);
    return res.status(200).json({msg: `Hello, here's your ip ${ip}`});
}

export default {
    getIp
};