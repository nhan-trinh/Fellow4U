const { Tour } = require("../home/tour.model");
const { Guide } = require("../home/guide.model");
const { Trip } = require("./trip.model");

async function seedTripsForUser(userId) {
  const existingCount = await Trip.countDocuments({ userId });
  if (existingCount > 0) return;

  const tours = await Tour.find().sort({ createdAt: 1 }).limit(2);
  const guides = await Guide.find().sort({ createdAt: 1 }).limit(2);
  if (tours.length < 2 || guides.length < 2) return;

  await Trip.insertMany([
    {
      userId,
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
      userId,
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
    {
      userId,
      title: "Old Town Memory",
      location: "Chiang Mai",
      status: "past",
      startDate: new Date(Date.now() - 20 * 24 * 60 * 60 * 1000),
      endDate: new Date(Date.now() - 18 * 24 * 60 * 60 * 1000),
      participants: 2,
      totalPrice: 160,
    },
    {
      userId,
      title: "Tokyo Wish Trip",
      location: "Tokyo",
      status: "wishlist",
      startDate: new Date(Date.now() + 40 * 24 * 60 * 60 * 1000),
      endDate: new Date(Date.now() + 45 * 24 * 60 * 60 * 1000),
      participants: 2,
      totalPrice: 900,
    },
  ]);
}

module.exports = { seedTripsForUser };
