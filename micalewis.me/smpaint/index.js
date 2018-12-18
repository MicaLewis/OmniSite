//index.js

const express = require('express')
const app = express()
const port = 8080

app.get('/smpaint', (req, res) => {res.send('Hello World!');
							console.log(`request`)})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))