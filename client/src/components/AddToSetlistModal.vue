<script lang="ts" setup>
import NewSetlistModal from "@/components/NewSetlistModal.vue";
import SetlistItem from "@/components/SetlistItem.vue";
import { useFetch } from "@/composables";
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
  <IonModal>
    <Authenticated>
      <IonHeader>
        <IonToolbar>
          <IonButtons slot="start">
            <IonButton role="cancel" @click="modalController.dismiss()"> Cancel </IonButton>
          </IonButtons>
          <IonTitle>Add to Setlist</IonTitle>
          <IonButtons slot="end">
            <IonButton role="cancel" @click="newModal()"> New setlist </IonButton>
          </IonButtons>
        </IonToolbar>
      </IonHeader>
      <Loading>
        <IonContent class="ion-padding">
          <DataSource v-slot="{ items }" src="setlists">
            <IonList>
              <SetlistItem
                v-for="setlist in items"
                :key="setlist.id"
                v-bind="setlist"
                @click.prevent="add(setlist)"
              />
            </IonList>
          </DataSource>
        </IonContent>
      </Loading>
    </Authenticated>
  </IonModal>
</template>
