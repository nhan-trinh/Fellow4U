const { z } = require("zod");

const searchSchema = z.object({
  body: z.object({}).passthrough(),
  params: z.object({}).passthrough(),
  query: z.object({
    keyword: z.string().optional(),
    location: z.string().optional(),
    category: z.string().optional(),
    page: z.coerce.number().int().positive().default(1),
    limit: z.coerce.number().int().positive().max(50).default(10),
  }),
});

module.exports = { searchSchema };
