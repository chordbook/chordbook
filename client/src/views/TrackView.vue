<script setup lang="ts">
import SongsheetItem from "@/components/SongsheetItem.vue";
import { useRouter } from "vue-router";

import type { Songsheet } from "@/api";

const router = useRouter();

defineProps<{ id: string }>();

function loaded({ data }: { data: Songsheet[] }) {
  // Redirect to the only version if there is only one
  if (data.length === 1) {
    const [{ id }] = data;
    router.replace(`/songsheets/${id}`);
  }
}
</script>

<template>
  <AppView>
    <Head>
      <title>Versions</title>
    </Head>
    <IonHeader>
      <IonToolbar>
        <IonButtons slot="start">
          <IonBackButton text="" default-href="/" />
        </IonButtons>
        <IonTitle>Versions</IonTitle>
      </IonToolbar>
    </IonHeader>
    <IonContent fullscreen class="main-content">
      <IonList>
        <DataSource
          v-slot="{ items }: { items: Songsheet[] }"
          :src="`tracks/${id}/songsheets`"
          @load="loaded"
        >
          <SongsheetItem v-for="songsheet in items" :key="songsheet.id" v-bind="songsheet" />
        </DataSource>
      </IonList>
    </IonContent>
  </AppView>
</template>
