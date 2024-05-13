import { sentryVitePlugin } from "@sentry/vite-plugin";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import { VitePWA } from "vite-plugin-pwa";
import svgLoader from "vite-svg-loader";
import { string } from "rollup-plugin-string";
import manifest from "./client/manifest.json";
import path from "path";

const root = path.resolve(__dirname, "client");

// https://vitejs.dev/config/
export default defineConfig({
  envDir: __dirname,
  envPrefix: "APP",
  root,
  build: {
    sourcemap: true,
    outDir: path.resolve(__dirname, "public"),
    emptyOutDir: true,
  },
  css: {
    devSourcemap: true,
  },
  plugins: [
    vue(),
    svgLoader(),
    VitePWA({
      strategies: "injectManifest",
      registerType: "autoUpdate",
      srcDir: "src/service_workers",
      filename: "offline.js",
      workbox: {
        sourcemap: true,
      },
      devOptions: {
        enabled: !!process.env.APP_PWA,
        type: "module",
        navigateFallback: "index.html",
      },
      manifest,
    }),
    string({ include: "**/*.snippets" }),
    sentryVitePlugin(),
  ],
  resolve: {
    alias: {
      "@": path.resolve(root, "src"),
    },
  },
  test: {
    globals: true,
    environment: "jsdom",
  },
});
