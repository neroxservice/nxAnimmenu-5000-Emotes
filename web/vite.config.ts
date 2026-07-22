import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import tailwindcss from '@tailwindcss/vite';

// FiveM NUI serves the built UI from a fixed path. We output to `dist/`
// inside this `web/` folder and the `fxmanifest.lua` references it.
// `base: './'` is mandatory so Vite emits relative asset URLs (FiveM CEF
// loads the page from a `nui://` origin and absolute paths break).
export default defineConfig({
  plugins: [svelte(), tailwindcss()],
  base: './',
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    target: 'esnext',
    cssCodeSplit: false,
    assetsInlineLimit: 0,
  },
  server: {
    port: 5173,
    strictPort: true,
  },
});
