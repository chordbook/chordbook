<template>
  <ion-app>
    <reload-pwa />
    <ion-split-pane
      content-id="main"
      when="md"
    >
      <app-menu content-id="main" />
      <ion-router-outlet id="main" />
    </ion-split-pane>
  </ion-app>
</template>

<script>
import { IonApp, IonRouterOutlet, IonSplitPane } from '@ionic/vue'
import ReloadPwa from '@/components/reload-pwa.vue'
import AppMenu from '@/components/menu.vue'
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'App',

  components: {
    IonApp,
    ReloadPwa,
    IonSplitPane,
    AppMenu,
    IonRouterOutlet
  },

  errorCaptured (error, instance, info) {
    window.captureError && window.captureError(error)
  }
})
</script>

<style scoped>
ion-split-pane {
  --side-max-width: 220px;
}
</style>
