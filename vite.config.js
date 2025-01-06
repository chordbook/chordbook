import { sentryVitePlugin } from "@sentry/vite-plugin";
import vue from "@vitejs/plugin-vue";
import path from "path";
import { string } from "rollup-plugin-string";
import { defineConfig } from "vite";
import { VitePWA } from "vite-plugin-pwa";
import vueDevTools from "vite-plugin-vue-devtools";
import svgLoader from "vite-svg-loader";
import manifest from "./client/manifest.json";

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
    vueDevTools(),
    svgLoader(),
    VitePWA({
      strategies: "injectManifest",
      registerType: "autoUpdate",
      srcDir: "src/service_workers",
      filename: "offline.ts",
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
    sentryVitePlugin({ disable: !process.env.APP_SENTRY_DSN }),
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
