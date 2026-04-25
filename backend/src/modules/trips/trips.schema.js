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

module.exports = { listTripsSchema, tripDetailSchema };
