const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    passwordHash: { type: String, required: true },
    name: { type: String, required: true },
    avatarUrl: { type: String, default: "" },
    bio: { type: String, default: "" },
    phone: { type: String, default: "" },
    role: { type: String, enum: ["traveler", "guide", "admin"], default: "traveler" },
    preferences: {
      languages: { type: [String], default: [] },
      interests: { type: [String], default: [] },
      budgetRange: { type: String, default: "" },
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);
module.exports = { User };
