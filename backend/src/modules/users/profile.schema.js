const { z } = require("zod");

const updateProfileSchema = z.object({
  body: z.object({
    name: z.string().min(2).optional(),
    bio: z.string().max(500).optional(),
    avatarUrl: z.string().url().optional(),
    phone: z.string().max(30).optional(),
    preferences: z
      .object({
        languages: z.array(z.string()).optional(),
        interests: z.array(z.string()).optional(),
        budgetRange: z.string().optional(),
      })
      .optional(),
  }),
  query: z.object({}).passthrough(),
  params: z.object({}).passthrough(),
});

module.exports = { updateProfileSchema };
