const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
require("dotenv").config();
const appRoutes = require("./routes");
const connectDB = require("./database");

connectDB();

const app = express();

// app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.get("/", (req, res) => {
  return res.send({ message: "Flutter Product API", success: true });
});

app.use("/api", appRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () =>
  console.log(`Server started on http://127.0.0.1:${PORT}`)
);
