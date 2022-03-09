import './application.scss'

import { createApp } from 'vue'
import { IonicVue } from '@ionic/vue'
import { createPinia } from 'pinia'
import App from './views/App.vue'
import VueAxios from 'vue-axios'
import client from './client'
import router from './router'
import telemetry from './telemetry'

const pinia = createPinia()

const app = createApp(App)
  .use(IonicVue)
  .use(VueAxios, client)
  .use(pinia)
  .use(router)

router.isReady().then(() => {
  telemetry()
  app.mount('[data-behavior=vue]')
})
