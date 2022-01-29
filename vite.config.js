import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { VitePWA } from 'vite-plugin-pwa'
import svgLoader from 'vite-svg-loader'
import Icons from 'unplugin-icons/vite'
import { FileSystemIconLoader } from 'unplugin-icons/loaders'
import IconsResolver from 'unplugin-icons/resolver'
import Components from 'unplugin-vue-components/vite'
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
    string({ include: '**/*.snippets' }),
    Icons({
      compiler: 'vue3',
      defaultClass: 'icon',
      customCollections: {
        app: FileSystemIconLoader('./app/frontend/icons')
      }
    }),
    Components({
      dts: false,
      resolvers: [
        IconsResolver({
          prefix: 'icon',
          customCollections: ['app']
        })
      ]
    })
  ],
  resolve: {
    alias: {
      '@': root,
      handlebars: 'handlebars/dist/handlebars.js'
    }
  }
})
