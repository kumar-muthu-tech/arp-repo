import { defineCollection, z } from 'astro:content';

const blogSchema = z.object({
  title: z.string(),
  description: z.string().optional(),
  pubDate: z.string().transform((value) => new Date(value)),
  tags: z.array(z.string()).optional().default([]),
  draft: z.boolean().optional().default(false)
});

const agentSchema = z.object({
  title: z.string(),
  description: z.string()
});

export const collections = {
  blog: defineCollection({ schema: blogSchema }),
  agent: defineCollection({ schema: agentSchema })
};