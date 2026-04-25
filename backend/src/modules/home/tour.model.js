const mongoose = require("mongoose");

const tourSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    location: { type: String, required: true },
    images: { type: [String], default: [] },
    tags: { type: [String], default: [] },
    duration: { type: Number, default: 1 },
    priceFrom: { type: Number, default: 0 },
    rating: { type: Number, default: 0 },
    summary: { type: String, default: "" },
  },
  { timestamps: true }
);

const Tour = mongoose.model("Tour", tourSchema);
module.exports = { Tour };
