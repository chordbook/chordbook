<script setup>
import { toastController } from "@ionic/vue";
import * as icons from "@/icons";
import useLibraryStore from "@/stores/library";

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
});

const library = useLibraryStore(props.id);

async function toast(message) {
  const toast = await toastController.create({ message, duration: 3000 });
  return toast.present();
}
</script>

<template>
  <ion-button
    v-if="library.exists"
    v-tooltip="'Remove from library'"
    color="success"
    @click="library.remove().then(() => toast('Removed from your library'))"
  >
    <ion-icon slot="icon-only" :icon="icons.saved" />
  </ion-button>

  <ion-button
    v-else
    v-tooltip="'Add to library'"
    @click="library.add().then(() => toast('Added to your library'))"
  >
    <ion-icon slot="icon-only" :icon="icons.save" />
  </ion-button>
</template>
