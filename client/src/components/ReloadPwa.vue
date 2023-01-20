<script setup>
import { registerSW } from 'virtual:pwa-register'
import { ref, watchEffect } from 'vue'
import { UseOnline } from '@vueuse/components'
import { offline } from '@/icons'
import { useFlipper } from '@/useFlipper'

const pwaEnabled = useFlipper('pwa').isEnabled
const installPromptEnabled = useFlipper('installPrompt').isEnabled

const offlineReady = ref(false)
const installPrompt = ref(null)

watchEffect(() => {
  if (!pwaEnabled.value) return

  console.info('PWA enabled, registering service worker...')
  registerSW({
    immediate: true,
    onOfflineReady () { offlineReady.value = true }
  })
})

// Save prompt for installing to home screen
// https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Add_to_home_screen
window.addEventListener('beforeinstallprompt', (e) => {
  // Stash the event so it can be triggered later.
  installPrompt.value = e
  console.debug('PWA: saved install prompt')
})

function addToHomeScreen (e) {
  // Show the prompt
  installPrompt.value.prompt()
  // Wait for the user to respond to the prompt
  installPrompt.value.userChoice.then((choiceResult) => {
    console.log('Response to A2HS prompt', choiceResult)
    installPrompt.value = null
  })
}
</script>

<template>
  <ion-toast
    :is-open="offlineReady"
    message="Ready to work offline."
    duration="3000"
    :buttons="[{ text: 'Ok', role: 'cancel' }]"
  />
  <ion-toast
    :is-open="installPrompt && installPromptEnabled"
    message="Add to home screen?"
    position="top"
    :buttons="[
      { text: 'Not Now', role: 'cancel' },
      { text: 'Add', handler: addToHomeScreen }
    ]"
    :duration="5000"
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
