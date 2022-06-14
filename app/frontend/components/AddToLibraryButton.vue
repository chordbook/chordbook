<script setup>
import { defineProps } from 'vue'
import { toastController } from '@ionic/vue'
import * as icons from '@/icons'
import useLibraryStore from '@/stores/library'

const props = defineProps({
  uid: {
    type: String,
    required: true
  }
})

const library = useLibraryStore(props.uid)

async function toast (message) {
  const toast = await toastController.create({ message, duration: 3000 })
  return toast.present()
}
</script>

<template>
  <ion-button
    v-if="library.exists"
    color="success"
    @click="library.remove().then(() => toast('Removed from your library'))"
  >
    <ion-icon
      slot="icon-only"
      :icon="icons.saved"
    />
  </ion-button>

  <ion-button
    v-else
    @click="library.add().then(() => toast('Added to your library'))"
  >
    <ion-icon
      slot="icon-only"
      :icon="icons.save"
    />
  </ion-button>
</template>
