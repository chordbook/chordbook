<script lang="ts" setup>
import * as icons from "@/icons";
import useLibraryStore from "@/stores/library";
import { toastController } from "@ionic/vue";

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
});

const library = useLibraryStore(props.id);

async function toast(message: string) {
  const toast = await toastController.create({ message, duration: 3000 });
  return toast.present();
}
</script>

<template>
  <IonButton
    v-if="library.exists"
    v-tooltip="'Remove from library'"
    color="success"
    @click="library.remove().then(() => toast('Removed from your library'))"
  >
    <IonIcon slot="icon-only" :icon="icons.saved" />
  </IonButton>

  <IonButton
    v-else
    v-tooltip="'Add to library'"
    @click="library.add().then(() => toast('Added to your library'))"
  >
    <IonIcon slot="icon-only" :icon="icons.save" />
  </IonButton>
</template>
