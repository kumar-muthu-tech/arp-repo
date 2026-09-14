import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import tailwind from '@astrojs/tailwind';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';

export default defineConfig({
  site: 'https://aeroplanetaai.com',
  integrations: [
    mdx({
      remarkPlugins: [remarkMath],
      rehypePlugins: [rehypeKatex]
    }),
    tailwind()
  ],
  markdown: {
    // Shiki theme; rehype-shiki also configured above
    shikiConfig: { theme: 'github-dark' }
  }
});
