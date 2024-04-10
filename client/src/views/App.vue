<template>
  <ion-app :class="platformClasses">
    <reload-pwa />
    <ion-split-pane
      content-id="main"
      when="md"
      :disabled="route.meta?.menu === false"
    >
      <app-menu content-id="main" />
      <ion-router-outlet id="main" />
    </ion-split-pane>
    <modal-view />
  </ion-app>
</template>

<script setup>
import ReloadPwa from '@/components/ReloadPwa.vue'
import AppMenu from '@/components/AppMenu.vue'
import ModalView from '@/views/ModalView.vue'
import { useRoute } from 'vue-router'
import { getPlatforms } from '@ionic/vue';

const platformClasses = getPlatforms().map(platform => `platform-${platform}`)
console.log('platformClasses', platformClasses)

const route = useRoute()
</script>

<style scoped>
ion-split-pane {
  --side-width: 180px;
  --side-max-width: var(--side-width);
  --side-min-width: var(--side-width);
}
</style>
