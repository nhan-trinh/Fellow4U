const mongoose = require("mongoose");
const { ok } = require("../../shared/response");
const { Trip } = require("./trip.model");

async function getMyTrips(req, res, next) {
  try {
    const { status, page, limit } = req.validated.query;
    const filter = { userId: req.user._id };
    if (status) filter.status = status;
    const skip = (page - 1) * limit;
    const [items, total] = await Promise.all([
      Trip.find(filter).sort({ startDate: 1, createdAt: -1 }).skip(skip).limit(limit),
      Trip.countDocuments(filter),
    ]);
    return ok(
      res,
      "My trips fetched",
      items,
      { page, limit, total, totalPages: Math.ceil(total / limit) }
    );
  } catch (error) {
    return next(error);
  }
}

async function getTripDetail(req, res, next) {
  try {
    const { tripId } = req.validated.params;
    if (!mongoose.isValidObjectId(tripId)) {
      const err = new Error("Invalid trip id");
      err.status = 400;
      err.code = "BAD_REQUEST";
      throw err;
    }
    const trip = await Trip.findOne({ _id: tripId, userId: req.user._id });
    if (!trip) {
      const err = new Error("Trip not found");
      err.status = 404;
      err.code = "NOT_FOUND";
      throw err;
    }
    return ok(res, "Trip detail fetched", trip);
  } catch (error) {
    return next(error);
  }
}

module.exports = { getMyTrips, getTripDetail };
