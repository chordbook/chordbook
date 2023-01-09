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
    <user-signin-modal />
    <user-signup-modal />
  </ion-app>
</template>

<script setup>
import ReloadPwa from '@/components/ReloadPwa.vue'
import AppMenu from '@/components/AppMenu.vue'
import UserSigninModal from './UserSigninModal.vue'
import UserSignupModal from './UserSignupModal.vue'
</script>

<style scoped>
ion-split-pane {
  --side-max-width: 220px;
}
</style>
