const { User } = require("../modules/users/user.model");
const { Tour } = require("../modules/home/tour.model");
const { Guide } = require("../modules/home/guide.model");
const { Trip } = require("../modules/trips/trip.model");
const bcrypt = require("bcrypt");

async function seedMvpData() {
  const usersCount = await User.countDocuments();
  if (usersCount > 0) return;

  const passwordHash = await bcrypt.hash("123456", 10);
  const user = await User.create({
    email: "demo@fellow4u.com",
    passwordHash,
    name: "Demo Traveler",
    bio: "Love travel and local experiences.",
  });

  const tours = await Tour.insertMany([
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

  const guides = await Guide.insertMany([
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

  await Trip.insertMany([
    {
      userId: user._id,
      tourId: tours[0]._id,
      guideId: guides[0]._id,
      title: "Street Food Weekend",
      location: "Bangkok",
      status: "current",
      startDate: new Date(),
      endDate: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000),
      participants: 2,
      totalPrice: 240,
    },
    {
      userId: user._id,
      tourId: tours[1]._id,
      guideId: guides[1]._id,
      title: "Temple Discovery",
      location: "Chiang Mai",
      status: "next",
      startDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000),
      endDate: new Date(Date.now() + 16 * 24 * 60 * 60 * 1000),
      participants: 1,
      totalPrice: 180,
    },
  ]);
}

module.exports = { seedMvpData };
