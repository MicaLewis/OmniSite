const express = require('express')
const app = express()
const port = 443
var path = require('path');

app.use(express.static('public'))

app.listen(port, () => console.log('Example app listening on port %d', port))

app.get('/', (req, res) => res.sendFile(path.join(__dirname + '/index.html')))