<template>
  <ion-app>
    <reload-pwa />
    <div class="grow flex h-full">
      <app-header />
      <main class="bg-white flex-1 overflow-auto dark:bg-gray-800 dark:text-gray-200 relative">
        <ion-router-outlet />
      </main>
    </div>
  </ion-app>
</template>

<script>
import { IonApp, IonRouterOutlet } from '@ionic/vue'
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'App',
  components: {
    IonApp,
    IonRouterOutlet
  },
  errorCaptured (error, instance, info) {
    window.captureError && window.captureError(error)
  }
})
</script>
