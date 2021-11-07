import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'
import { VitePWA } from 'vite-plugin-pwa'
import Icons from 'unplugin-icons/vite'
import { FileSystemIconLoader } from 'unplugin-icons/loaders'
import IconsResolver from 'unplugin-icons/resolver'
import Components from 'unplugin-vue-components/vite'
import { string } from "rollup-plugin-string"

export default defineConfig({
  plugins: [
    vue(),
    RubyPlugin(),
    VitePWA({
      mode: "development",
      base: "/",
      srcDir: "service_workers",
      filename: "service-worker.js",
      includeAssets: ["/favicon-16x16.png"],
      strategies: "injectManifest",
      manifest: {
        short_name: "Chord Book",
        name: "Chord Book",
        icons: [
          {
            src: "/android-chrome-192.png",
            sizes: "192x192",
            type: "image/png"
          },
          {
            src: "/android-chrome-512.png",
            sizes: "512x512",
            type: "image/png"
          }
        ],
        start_url: "/",
        background_color: "#3367D6",
        display: "standalone",
        scope: "/",
        theme_color: "#3367D6"
      }
    }),
    string({ include: "**/*.snippets" }),
    Icons({
      compiler: 'vue3',
      defaultClass: 'icon',
      customCollections: {
        app: FileSystemIconLoader('app/packs/icons'),
      },
    }),
    Components({
      dts: true,
      resolvers: [
        IconsResolver({
          prefix: 'icon',
          customCollections: ['app'],
        }),
      ],
    }),
  ],
  resolve: {
    alias: {
      'handlebars' : 'handlebars/dist/handlebars.js',
      'vue': 'vue/dist/vue.esm-bundler.js'
    }
  }
})
