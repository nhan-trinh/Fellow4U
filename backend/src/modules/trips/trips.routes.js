const express = require("express");
const { authGuard } = require("../../middlewares/auth.middleware");
const { validate } = require("../../middlewares/validate.middleware");
const { getMyTrips, getTripDetail } = require("./trips.controller");
const { listTripsSchema, tripDetailSchema } = require("./trips.schema");

function createTripsRouter(env) {
  const tripsRouter = express.Router();
  tripsRouter.use(authGuard(env));
  tripsRouter.get("/", validate(listTripsSchema), getMyTrips);
  tripsRouter.get("/:tripId", validate(tripDetailSchema), getTripDetail);
  return tripsRouter;
}

module.exports = { createTripsRouter };
