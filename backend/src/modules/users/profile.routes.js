const express = require("express");
const { authGuard } = require("../../middlewares/auth.middleware");
const { validate } = require("../../middlewares/validate.middleware");
const { getMe, updateMe } = require("./profile.controller");
const { updateProfileSchema } = require("./profile.schema");

function createProfileRouter(env) {
  const profileRouter = express.Router();
  profileRouter.use(authGuard(env));
  profileRouter.get("/me", getMe);
  profileRouter.patch("/me", validate(updateProfileSchema), updateMe);
  return profileRouter;
}

module.exports = { createProfileRouter };
