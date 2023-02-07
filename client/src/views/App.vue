<template>
  <ion-app>
    <reload-pwa />
    <ion-split-pane
      content-id="main"
      when="lg"
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
</script>

<style scoped>
ion-split-pane {
  --side-width: 200px;
  --side-max-width: var(--side-width);
  --side-min-width: var(--side-width);
}
</style>
