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
    <user-signin-modal v-if="!auth.isAuthenticated" />
    <user-signup-modal v-if="!auth.isAuthenticated" />
  </ion-app>
</template>

<script>
import { IonApp, IonRouterOutlet, IonSplitPane } from '@ionic/vue'
import ReloadPwa from '@/components/reload-pwa.vue'
import AppMenu from '@/components/menu.vue'
import { defineComponent } from 'vue'
import useAuthStore from '@/stores/auth'
import UserSigninModal from './UserSigninModal.vue'
import UserSignupModal from './UserSignupModal.vue'

export default defineComponent({
  name: 'App',

  components: {
    IonApp,
    ReloadPwa,
    IonSplitPane,
    AppMenu,
    IonRouterOutlet,
    UserSigninModal,
    UserSignupModal
  },

  setup () {
    const auth = useAuthStore()
    auth.refresh()

    return { auth }
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
