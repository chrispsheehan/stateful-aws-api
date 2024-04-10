import app from './app'
const port = process.env.PORT

app.listen(port)
console.log(`LOCAL app listening on http://localhost:${port}`)