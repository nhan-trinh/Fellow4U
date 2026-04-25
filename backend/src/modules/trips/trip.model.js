const mongoose = require("mongoose");

const tripSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    tourId: { type: mongoose.Schema.Types.ObjectId, ref: "Tour", default: null },
    guideId: { type: mongoose.Schema.Types.ObjectId, ref: "Guide", default: null },
    title: { type: String, required: true },
    location: { type: String, default: "" },
    status: {
      type: String,
      enum: ["current", "next", "past", "wishlist"],
      required: true,
    },
    startDate: { type: Date, default: null },
    endDate: { type: Date, default: null },
    participants: { type: Number, default: 1 },
    totalPrice: { type: Number, default: 0 },
    notes: { type: String, default: "" },
    images: { type: [String], default: [] },
  },
  { timestamps: true }
);

const Trip = mongoose.model("Trip", tripSchema);
module.exports = { Trip };
