import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const services = defineCollection({
  loader: glob({ pattern: '*.md', base: './src/content/services' }),
  schema: z.object({
    number: z.string(),
    order: z.number(),
    title: z.string(),
    summary: z.string(),
  }),
});

const work = defineCollection({
  loader: glob({ pattern: '*.md', base: './src/content/work' }),
  schema: z.object({
    order: z.number(),
    title: z.string(),
    tag: z.string(),
    summary: z.string(),
    public: z.boolean().default(false),
    highlights: z.array(z.string()).default([]),
  }),
});

export const collections = { services, work };
