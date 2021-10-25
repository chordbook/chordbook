import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [
    vue(),
    RubyPlugin(),
  ],
  resolve: {
    alias: {
      'handlebars' : 'handlebars/dist/handlebars.js',
      'vue': 'vue/dist/vue.esm-bundler.js'
    }
  }
})
