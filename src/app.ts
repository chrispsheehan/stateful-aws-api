import express from 'express';
import awsServerlessExpress from 'aws-serverless-express';
import generalHandlers from './generalHandlers';
import githubHandlers from './githubHandlers';

const app = express();

const basePath = "/api"

app.get('/hello', (_req, res) => {
  res.status(200).json({msg: "Hello, this is your API"});
});

app
  .route(`${basePath}/ip`)
  .get(generalHandlers.getIp);

app
  .route(`${basePath}/git/stats`)
  .get(githubHandlers.getGitStats);

const server = awsServerlessExpress.createServer(app);

export const handler = (event: any, context: any) => {
  awsServerlessExpress.proxy(server, event, context);
};

export default app;
