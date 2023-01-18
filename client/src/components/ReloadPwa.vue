<script setup>
import { registerSW } from 'virtual:pwa-register'
import { ref } from 'vue'
import { UseOnline } from '@vueuse/components'
import { offline } from '@/icons'

const localPwa = localStorage.getItem('pwa')
const pwaEnabled = (import.meta.env.APP_PWA || localPwa) && localPwa !== 'false'
const offlineReady = ref(false)

if (pwaEnabled) {
  console.info('PWA enabled, registering service worker...')
  registerSW({
    immediate: true,
    onOfflineReady () { offlineReady.value = true }
  })
} else {
  console.info('PWA disabled')
}
</script>

<template>
  <ion-toast
    :is-open="offlineReady"
    message="Ready to work offline."
    duration="3000"
    :buttons="[{ text: 'Ok', role: 'cancel' }]"
  />
  <UseOnline v-slot="{ isOnline }">
    <ion-toast
      :is-open="pwaEnabled && !isOnline"
      :icon="offline"
      header="It looks like you are offline"
      message="Some functionality will be limited."
      duration="5000"
      :buttons="[{ text: 'Ok', role: 'cancel' }]"
    />
  </UseOnline>
</template>
