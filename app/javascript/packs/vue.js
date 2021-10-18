import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'
import Songsheet from '../components/songsheet'

Vue.use(TurbolinksAdapter)

Vue.component('songsheet', Songsheet)

document.addEventListener('turbolinks:load', () => {
  window.app = new Vue({
    el: '[data-behavior=vue]',
    components: { App }
  })
})
