import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  window.app = new Vue({
    el: '#app',
    data: () => {
      return {
        message: 'Can you say hello?',
        now: new Date()
      }
    },
    components: { App }
  })
})
