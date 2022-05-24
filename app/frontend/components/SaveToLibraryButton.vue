<script setup>
import { defineProps, ref, unref } from 'vue'
import { useFetch } from '@/client'
import { IonButton, IonIcon, toastController } from '@ionic/vue'
import * as icons from '@/icons'

const props = defineProps({
  uid: {
    type: String,
    required: true
  }
})

const exists = ref(false)

useFetch('library', { params: props }).then(({ statusCode }) => {
  exists.value = unref(statusCode) === 200
})

async function toast (message) {
  const toast = await toastController.create({ message, duration: 3000 })
  toast.present()
}

function add () {
  useFetch('library').post(props).then(async () => {
    exists.value = true
    toast('Added to your library')
  })
}

function remove () {
  useFetch('library').delete(props).then(() => {
    exists.value = false
    toast('Removed from your library')
  })
}
</script>

<template>
  <ion-button
    v-if="exists"
    color="success"
    @click="remove"
  >
    <ion-icon
      slot="icon-only"
      :icon="icons.saved"
    />
  </ion-button>

  <ion-button
    v-else
    @click="add"
  >
    <ion-icon
      slot="icon-only"
      :icon="icons.save"
    />
  </ion-button>
</template>
