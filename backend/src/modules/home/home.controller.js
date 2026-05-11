const { ok } = require("../../shared/response");
const { Tour } = require("./tour.model");
const { Guide } = require("./guide.model");

async function getHome(req, res, next) {
  try {
    const [featuredTours, bestGuides, topJourneys] = await Promise.all([
      Tour.find().sort({ rating: -1 }).limit(6),
      Guide.find().sort({ rating: -1 }).limit(6),
      Tour.find().sort({ createdAt: -1 }).limit(6),
    ]);
    return ok(res, "Home data fetched", {
      featuredTours,
      bestGuides,
      topJourneys,
    });
  } catch (error) {
    return next(error);
  }
}

async function searchHome(req, res, next) {
  try {
    const {
      keyword = "",
      location,
      category,
      page,
      limit,
    } = req.validated.query;
    const filter = {};
    if (keyword) {
      filter.$or = [
        { title: { $regex: keyword, $options: "i" } },
        { tags: { $regex: keyword, $options: "i" } },
        { location: { $regex: keyword, $options: "i" } },
      ];
    }
    if (location) {
      filter.location = { $regex: location, $options: "i" };
    }
    if (category) {
      filter.tags = { $regex: category, $options: "i" };
    }
    const skip = (page - 1) * limit;
    const [items, total] = await Promise.all([
      Tour.find(filter).skip(skip).limit(limit).sort({ createdAt: -1 }),
      Tour.countDocuments(filter),
    ]);
    return ok(res, "Search result fetched", items, {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    });
  } catch (error) {
    return next(error);
  }
}

async function getDetails(req, res, next) {
  try {
    const { id, type } = req.params;
    let details;

    if (type === "tour") {
      details = await Tour.findById(id);
    } else if (type === "guide") {
      details = await Guide.findById(id);
    } else {
      return res
        .status(400)
        .json({ message: "Invalid type parameter. Use 'tour' or 'guide'" });
    }

    if (!details) {
      return res.status(404).json({ message: `${type} not found` });
    }

    return ok(res, `${type} details fetched successfully`, details);
  } catch (error) {
    return next(error);
  }
}

module.exports = { getHome, searchHome, getDetails };
