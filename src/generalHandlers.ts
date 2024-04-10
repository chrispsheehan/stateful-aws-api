import { Request, Response } from 'express';

function getIp(req: Request, res: Response): Response {
    const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress 
    return res.status(200).json({msg: `Hello, here's your ip ${ip}`});
}

export default {
    getIp
};