const express = require('express');
const app = express();
const port = process.env.PORT || 80;

throw new Error("Simulating a crash");

app.get('/', (req, res) => {
    res.send('Hello, World!');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});