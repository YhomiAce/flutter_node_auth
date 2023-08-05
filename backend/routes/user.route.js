const express = require('express');
const AuthGuard = require("../middleware/auth");
const AuthController = require("../controllers/AuthController");

const router = express.Router();

router.get('/user', AuthGuard, AuthController.getUser );

module.exports = router;