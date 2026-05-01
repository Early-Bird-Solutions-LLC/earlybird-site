// @ts-check
import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://earlybirdsolutions.com',
  output: 'static',
  build: {
    inlineStylesheets: 'auto',
  },
  compressHTML: true,
});
