import './application.scss'
import { createApp } from 'vue'
import VueAxios from 'vue-axios'
import store from '~/store'
import router from '~/router'
import api from '~/api'

const components = import.meta.globEager('../components/*.vue')

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({})
  app.use(VueAxios, api)
  app.use(store)
  app.use(router)

  Object.entries(components).forEach(([path, definition]) => {
    const componentName = path.split('/').pop().replace(/\.vue$/, '')
    app.component(componentName, definition.default)
  })

  app.mount('[data-behavior=vue]')
})
