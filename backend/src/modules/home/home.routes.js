const express = require("express");
const { validate } = require("../../middlewares/validate.middleware");
const { searchSchema } = require("./home.schema");
const { getHome, searchHome } = require("./home.controller");

const homeRouter = express.Router();
homeRouter.get("/", getHome);
homeRouter.get("/search", validate(searchSchema), searchHome);

module.exports = { homeRouter };
