<template>
  <ion-app>
    <reload-pwa />
    <ion-router-outlet />
  </ion-app>
</template>

<script>
import { IonApp, IonRouterOutlet } from '@ionic/vue'
import ReloadPwa from '@/components/reload-pwa.vue'
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'App',

  components: {
    ReloadPwa,
    IonApp,
    IonRouterOutlet
  },

  errorCaptured (error, instance, info) {
    window.captureError && window.captureError(error)
  }
})
</script>
