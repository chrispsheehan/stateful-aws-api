import app from './app'
import { Request } from 'express';
const port = process.env.API_PORT

app.listen(port)

app.use((req: Request, _, next) => { 
    console.log(`Params: ${JSON.stringify(req.params)}`); // log out requests
    console.log(`Headers: ${JSON.stringify(req.headers)}`);
});

console.log(`LOCAL app listening on http://localhost:${port}`)