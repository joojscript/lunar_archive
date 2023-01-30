import react from "@astrojs/react";
import tailwind from "@astrojs/tailwind";
import compress from "astro-compress";
import { defineConfig } from "astro/config";

// https://astro.build/config
export default defineConfig({
  integrations: [
    react(),
    tailwind(),
    compress({
      css: false,
    }),
  ],
  vite: {
    esbuild: {
      minify: true,
    },
  },
});
