import express from 'express';
import awsServerlessExpress from 'aws-serverless-express';
import taskHandlers from './taskHandlers';

const app = express();
app.use(express.json());

const basePath = "/api"

app.get('/hello', (_req, res) => {
  res.status(200).json({msg: "Hello, this is your API"});
});

app.put(`${basePath}/task`, (_req, res) => { 
  taskHandlers.putTask(_req, res);
});

app.get(`${basePath}/task`, (_req, res) => { 
  taskHandlers.getTask(_req, res);
});

const server = awsServerlessExpress.createServer(app);

export const handler = (event: any, context: any) => {
  awsServerlessExpress.proxy(server, event, context);
};

export default app;
