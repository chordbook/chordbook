import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'
import Icons from 'unplugin-icons/vite'
import { FileSystemIconLoader } from 'unplugin-icons/loaders'
import IconsResolver from 'unplugin-icons/resolver'
import Components from 'unplugin-vue-components/vite'

export default defineConfig({
  plugins: [
    vue(),
    RubyPlugin(),
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
