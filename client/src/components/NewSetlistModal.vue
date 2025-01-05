<script lang="ts" setup>
import { useFetch } from "@/composables";
import { modalController } from "@ionic/vue";
import { reactive } from "vue";

const params = reactive<{ title?: string; description?: string }>({});

async function save() {
  const { data } = await useFetch("setlists").post({ setlist: params }).json();
  modalController.dismiss(data);
}
</script>

<template>
  <IonHeader>
    <IonToolbar>
      <IonTitle>New Setlist</IonTitle>
      <IonButtons slot="start">
        <IonButton role="cancel" @click="modalController.dismiss()"> Cancel </IonButton>
      </IonButtons>
    </IonToolbar>
  </IonHeader>
  <IonContent>
    <IonItem>
      <IonLabel position="stacked"> Setlist title </IonLabel>
      <IonInput v-model="params.title" />
    </IonItem>

    <IonItem>
      <IonLabel position="stacked"> Description </IonLabel>
      <IonTextarea v-model="params.description" />
    </IonItem>

    <div class="ion-padding">
      <IonButton expand="block" type="submit" @click="save"> Save </IonButton>
    </div>
  </IonContent>
</template>
