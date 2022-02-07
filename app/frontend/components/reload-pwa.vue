<template>
  <ion-toast
    :is-open="needRefresh"
    message="Updated content is available."
    position="top"
    :buttons="buttons"
    animated
  />
</template>

<script setup>
import { useRegisterSW } from 'virtual:pwa-register/vue'
import { IonToast } from '@ionic/vue'

const { needRefresh, updateServiceWorker } = useRegisterSW()

function close () {
  needRefresh.value = false
}

const buttons = [
  { text: 'Close', role: 'cancel', handler: close },
  { text: 'Update', handler: updateServiceWorker }
]
</script>
