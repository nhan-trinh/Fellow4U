const { z } = require("zod");

const listTripsSchema = z.object({
  body: z.object({}).passthrough(),
  params: z.object({}).passthrough(),
  query: z.object({
    status: z.enum(["current", "next", "past", "wishlist"]).optional(),
    page: z.coerce.number().int().positive().default(1),
    limit: z.coerce.number().int().positive().max(50).default(10),
  }),
});

const tripDetailSchema = z.object({
  body: z.object({}).passthrough(),
  query: z.object({}).passthrough(),
  params: z.object({
    tripId: z.string().min(8),
  }),
});

const createTripSchema = z.object({
  query: z.object({}).passthrough(),
  params: z.object({}).passthrough(),
  body: z.object({
    title: z.string().min(2),
    location: z.string().min(2),
    status: z.enum(["current", "next", "past", "wishlist"]).optional(),
    startDate: z.string().optional(),
    endDate: z.string().optional(),
    participants: z.coerce.number().int().positive().default(1),
    totalPrice: z.coerce.number().nonnegative().default(0),
    notes: z.string().optional(),
    images: z.array(z.string()).optional(),
  }),
});

const updateTripSchema = z.object({
  query: z.object({}).passthrough(),
  params: z.object({
    tripId: z.string().min(8),
  }),
  body: z.object({
    title: z.string().min(2).optional(),
    location: z.string().min(2).optional(),
    status: z.enum(["current", "next", "past", "wishlist"]).optional(),
    startDate: z.string().optional(),
    endDate: z.string().optional(),
    participants: z.coerce.number().int().positive().optional(),
    totalPrice: z.coerce.number().nonnegative().optional(),
    notes: z.string().optional(),
    images: z.array(z.string()).optional(),
  }),
});

module.exports = {
  listTripsSchema,
  tripDetailSchema,
  createTripSchema,
  updateTripSchema,
};
