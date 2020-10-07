const express = require("express");
const app = express();
const port = process.env.PORT | 3000;

app.get('/', (req, res) => {
    res.send('hello wrold');
});

app.listen(port, err => {
    if(err) console.error(err);
    else console.log()
});
