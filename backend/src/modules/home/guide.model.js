const mongoose = require("mongoose");

const guideSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    avatarUrl: { type: String, default: "" },
    rating: { type: Number, default: 0 },
    languages: { type: [String], default: [] },
    pricePerDay: { type: Number, default: 0 },
    location: { type: String, default: "" },
  },
  { timestamps: true }
);

const Guide = mongoose.model("Guide", guideSchema);
module.exports = { Guide };
