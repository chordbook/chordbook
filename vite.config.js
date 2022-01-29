import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { VitePWA } from 'vite-plugin-pwa'
import svgLoader from 'vite-svg-loader'
import { string } from 'rollup-plugin-string'
import manifest from './app/frontend/manifest.json'
import path from 'path'

const root = path.resolve(__dirname, 'app', 'frontend')

// https://vitejs.dev/config/
export default defineConfig({
  envDir: __dirname,
  envPrefix: 'APP',
  root,
  build: {
    sourcemap: true,
    outDir: path.resolve(__dirname, 'public')
  },
  plugins: [
    vue(),
    svgLoader(),
    VitePWA({
      srcDir: 'service_workers',
      filename: 'offline.js',
      workbox: {
        sourcemap: true
      },
      manifest
    }),
    string({ include: '**/*.snippets' })
  ],
  resolve: {
    alias: {
      '@': root,
      handlebars: 'handlebars/dist/handlebars.js'
    }
  }
})
