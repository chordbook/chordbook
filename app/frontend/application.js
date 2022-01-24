import './application.scss'

import { createApp } from 'vue'
import { IonicVue } from '@ionic/vue'
import App from './views/App.vue'
import VueAxios from 'vue-axios'
import store from './store'
import router from './router'
import api from './client'

// const components = import.meta.globEager('./components/*.vue')

const app = createApp(App)
  .use(IonicVue)
  .use(VueAxios, api)
  .use(store)
  .use(router)

router.isReady().then(() => {
  // Object.entries(components).forEach(([path, definition]) => {
  //   const componentName = path.split('/').pop().replace(/\.vue$/, '')
  //   app.component(componentName, definition.default)
  // })

  app.mount('[data-behavior=vue]')
})
