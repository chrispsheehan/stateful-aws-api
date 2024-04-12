import app from './app'
const port = process.env.API_PORT

app.listen(port)
console.log(`LOCAL app listening on http://localhost:${port}`)