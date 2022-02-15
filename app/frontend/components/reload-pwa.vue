<template>
  <ion-toast
    :is-open="needRefresh"
    message="Ready to work offline."
    duration="2000"
    :buttons="[{ text: 'Ok', role: 'cancel' }]"
  />
</template>

<script setup>
import { IonToast } from '@ionic/vue'
import { registerSW } from 'virtual:pwa-register'
import { ref } from 'vue'

const isOpen = ref(true)

registerSW({
  onOfflineReady () { isOpen.value = true }
})
</script>
