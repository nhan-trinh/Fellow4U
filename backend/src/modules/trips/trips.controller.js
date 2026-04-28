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

async function createTrip(req, res, next) {
  try {
    const payload = req.validated.body;
    const trip = await Trip.create({
      userId: req.user._id,
      title: payload.title,
      location: payload.location,
      status: payload.status || "next",
      startDate: payload.startDate ? new Date(payload.startDate) : null,
      endDate: payload.endDate ? new Date(payload.endDate) : null,
      participants: payload.participants ?? 1,
      totalPrice: payload.totalPrice ?? 0,
      notes: payload.notes ?? "",
      images: payload.images ?? [],
    });
    return ok(res, "Trip created", trip, null, 201);
  } catch (error) {
    return next(error);
  }
}

async function updateTrip(req, res, next) {
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

    const payload = req.validated.body;
    if (payload.title !== undefined) trip.title = payload.title;
    if (payload.location !== undefined) trip.location = payload.location;
    if (payload.status !== undefined) trip.status = payload.status;
    if (payload.startDate !== undefined) {
      trip.startDate = payload.startDate ? new Date(payload.startDate) : null;
    }
    if (payload.endDate !== undefined) {
      trip.endDate = payload.endDate ? new Date(payload.endDate) : null;
    }
    if (payload.participants !== undefined) trip.participants = payload.participants;
    if (payload.totalPrice !== undefined) trip.totalPrice = payload.totalPrice;
    if (payload.notes !== undefined) trip.notes = payload.notes;
    if (payload.images !== undefined) trip.images = payload.images;

    await trip.save();
    return ok(res, "Trip updated", trip);
  } catch (error) {
    return next(error);
  }
}

async function deleteTrip(req, res, next) {
  try {
    const { tripId } = req.validated.params;
    if (!mongoose.isValidObjectId(tripId)) {
      const err = new Error("Invalid trip id");
      err.status = 400;
      err.code = "BAD_REQUEST";
      throw err;
    }
    const trip = await Trip.findOneAndDelete({ _id: tripId, userId: req.user._id });
    if (!trip) {
      const err = new Error("Trip not found");
      err.status = 404;
      err.code = "NOT_FOUND";
      throw err;
    }
    return ok(res, "Trip deleted", null);
  } catch (error) {
    return next(error);
  }
}

module.exports = { getMyTrips, getTripDetail, createTrip, updateTrip, deleteTrip };
