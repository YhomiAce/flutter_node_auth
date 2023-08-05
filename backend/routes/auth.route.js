const express = require("express");
const AuthController = require("../controllers/AuthController");
const {
  validate,
  registerValidation,
  loginValidation,
} = require("../helpers/validator");

const router = express.Router();

router.post("/signup", registerValidation(), validate, AuthController.sigunp);

router.post("/login", loginValidation(), validate, AuthController.login);

module.exports = router;
