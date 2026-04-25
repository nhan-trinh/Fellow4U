const mongoose = require("mongoose");

async function connectDB(mongoUri) {
  try {
    await mongoose.connect(mongoUri);
    // Keep an explicit success log for local/dev visibility.
    console.log("MongoDB connected");
  } catch (error) {
    console.error("MongoDB connection failed:", error.message);
    throw error;
  }
}

module.exports = { connectDB };
