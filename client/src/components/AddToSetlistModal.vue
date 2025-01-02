<script lang="ts" setup>
import { useFetch } from "@/client";
import NewSetlistModal from "@/components/NewSetlistModal.vue";
import SetlistItem from "@/components/SetlistItem.vue";
import { modalController, toastController } from "@ionic/vue";

const props = defineProps<{
  id: string;
}>();

async function add(setlist: { id: string; title: string }) {
  await useFetch(`setlists/${setlist.id}/items`).post({ id: props.id });

  modalController.dismiss();

  return (
    await toastController.create({
      message: `Added to ${setlist.title}`,
      duration: 3000,
    })
  ).present();
}

async function newModal() {
  const modal = await modalController.create({ component: NewSetlistModal });
  modal.onDidDismiss().then(({ data }) => {
    if (data.value) add(data.value);
  });
  return modal.present();
}
</script>

<template>
  <ion-modal>
    <authenticated>
      <ion-header>
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-button role="cancel" @click="modalController.dismiss()"> Cancel </ion-button>
          </ion-buttons>
          <ion-title>Add to Setlist</ion-title>
          <ion-buttons slot="end">
            <ion-button role="cancel" @click="newModal()"> New setlist </ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content class="ion-padding">
        <loading>
          <data-source v-slot="{ items }" src="setlists">
            <ion-list>
              <setlist-item
                v-for="setlist in items"
                :key="setlist.id"
                v-bind="setlist"
                @click.prevent="add(setlist)"
              />
            </ion-list>
          </data-source>
        </loading>
      </ion-content>
    </authenticated>
  </ion-modal>
</template>
