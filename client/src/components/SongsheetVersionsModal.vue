<script lang="ts" setup>
import SongsheetItem from "@/components/SongsheetItem.vue";
import { modalController } from "@ionic/vue";

defineProps<{
  id: string;
  exclude?: string;
}>();
</script>

<template>
  <IonModal can-dismiss :breakpoints="[0.5, 1]" :initial-breakpoint="0.5">
    <AppView>
      <IonHeader>
        <IonToolbar>
          <IonButtons slot="start">
            <IonButton role="cancel" @click="modalController.dismiss()"> Cancel </IonButton>
          </IonButtons>
          <IonTitle>Alternate Versions</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent>
        <IonList>
          <DataSource v-slot="{ items }" :src="`tracks/${id}/songsheets`">
            <template v-for="version in items" :key="version.id">
              <SongsheetItem
                v-if="version.id !== exclude"
                v-bind="version"
                router-direction="replace"
                @click="modalController.dismiss()"
              />
            </template>
          </DataSource>
        </IonList>
      </IonContent>
    </AppView>
  </IonModal>
</template>
