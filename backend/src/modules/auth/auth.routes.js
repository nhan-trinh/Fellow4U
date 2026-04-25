const express = require("express");
const { validate } = require("../../middlewares/validate.middleware");
const { registerSchema, loginSchema, refreshSchema } = require("./auth.schema");
const { register, login, refreshToken, logout } = require("./auth.controller");

const authRouter = express.Router();

authRouter.post("/register", validate(registerSchema), register);
authRouter.post("/login", validate(loginSchema), login);
authRouter.post("/refresh-token", validate(refreshSchema), refreshToken);
authRouter.post("/logout", logout);

module.exports = { authRouter };
