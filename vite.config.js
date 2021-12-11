import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'
import { VitePWA } from 'vite-plugin-pwa'
import Icons from 'unplugin-icons/vite'
import { FileSystemIconLoader } from 'unplugin-icons/loaders'
import IconsResolver from 'unplugin-icons/resolver'
import Components from 'unplugin-vue-components/vite'
import { string } from 'rollup-plugin-string'
import manifest from './public/manifest.json'

export default defineConfig({
  build: {
    sourcemap: true
  },
  plugins: [
    vue(),
    RubyPlugin(),
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
        app: FileSystemIconLoader('app/frontend/icons')
      }
    }),
    Components({
      dts: true,
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
      handlebars: 'handlebars/dist/handlebars.js',
      vue: 'vue/dist/vue.esm-bundler.js'
    }
  }
})
