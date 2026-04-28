const express = require("express");
const { authGuard } = require("../../middlewares/auth.middleware");
const { validate } = require("../../middlewares/validate.middleware");
const {
  getMyTrips,
  getTripDetail,
  createTrip,
  updateTrip,
  deleteTrip,
} = require("./trips.controller");
const {
  listTripsSchema,
  tripDetailSchema,
  createTripSchema,
  updateTripSchema,
} = require("./trips.schema");

function createTripsRouter(env) {
  const tripsRouter = express.Router();
  tripsRouter.use(authGuard(env));
  tripsRouter.get("/", validate(listTripsSchema), getMyTrips);
  tripsRouter.post("/", validate(createTripSchema), createTrip);
  tripsRouter.get("/:tripId", validate(tripDetailSchema), getTripDetail);
  tripsRouter.patch("/:tripId", validate(updateTripSchema), updateTrip);
  tripsRouter.delete("/:tripId", validate(tripDetailSchema), deleteTrip);
  return tripsRouter;
}

module.exports = { createTripsRouter };
