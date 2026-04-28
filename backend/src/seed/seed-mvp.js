const { User } = require("../modules/users/user.model");
const { Tour } = require("../modules/home/tour.model");
const { Guide } = require("../modules/home/guide.model");
const { seedTripsForUser } = require("../modules/trips/trip-seed.service");
const bcrypt = require("bcrypt");

async function seedMvpData() {
  let user = await User.findOne({ email: "demo@fellow4u.com" });
  if (!user) {
    const passwordHash = await bcrypt.hash("123456", 10);
    user = await User.create({
      email: "demo@fellow4u.com",
      passwordHash,
      name: "Demo Traveler",
      bio: "Love travel and local experiences.",
    });
  }

  const toursCount = await Tour.countDocuments();
  if (toursCount === 0) {
    await Tour.insertMany([
      {
        title: "Bangkok Street Food Tour",
        location: "Bangkok",
        tags: ["food", "city", "culture"],
        duration: 2,
        priceFrom: 120,
        rating: 4.8,
        summary: "Discover hidden food spots.",
      },
      {
        title: "Chiang Mai Temple Journey",
        location: "Chiang Mai",
        tags: ["temple", "history"],
        duration: 3,
        priceFrom: 180,
        rating: 4.7,
        summary: "Explore ancient temples and local stories.",
      },
    ]);
  }

  const guidesCount = await Guide.countDocuments();
  if (guidesCount === 0) {
    await Guide.insertMany([
      {
        name: "Narin P.",
        rating: 4.9,
        languages: ["en", "th"],
        pricePerDay: 95,
        location: "Bangkok",
      },
      {
        name: "Mai S.",
        rating: 4.8,
        languages: ["en", "th", "jp"],
        pricePerDay: 120,
        location: "Chiang Mai",
      },
    ]);
  }

  await seedTripsForUser(user._id);
}

module.exports = { seedMvpData };
