import './application.scss'
import { createApp } from 'vue'
import VueAxios from 'vue-axios'
import store from './store'
import router from './router'
import api from './client'

const components = import.meta.globEager('./components/*.vue')

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({
    errorCaptured (error, instance, info) {
      window.captureError && window.captureError(error)
    }
  })
  app.use(VueAxios, api)
  app.use(store)
  app.use(router)

  Object.entries(components).forEach(([path, definition]) => {
    const componentName = path.split('/').pop().replace(/\.vue$/, '')
    app.component(componentName, definition.default)
  })

  app.mount('[data-behavior=vue]')
})
