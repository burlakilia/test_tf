const express = require('express');
const cors = require('cors');

const app = express();

const {PORT = 8000} = process.env;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cors());


app.get("/get_config", (req, res) => {
    return res.json({
        datetime: new Date().toISOString()
    });
});

app.listen(PORT, () => {
    console.log(`App listening at port ${PORT}`);
});