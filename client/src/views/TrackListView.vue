<script setup lang="ts">
import type { Track } from "@/api";
import TrackItem from "@/components/TrackItem.vue";
</script>

<template>
  <AppView>
    <Head>
      <title>Songs</title>
    </Head>
    <IonHeader translucent collapse="fade">
      <IonToolbar>
        <IonButtons slot="start">
          <IonBackButton text="" :default-href="$route.path.replace('/tracks', '')" />
        </IonButtons>
        <IonTitle>Songs</IonTitle>
      </IonToolbar>
    </IonHeader>

    <IonContent fullscreen class="main-content">
      <DataSource v-slot="{ items }: { items: Track[] }" :src="$route.path" :params="$route.query">
        <IonList>
          <TrackItem v-for="track in items" :key="track.id" v-bind="track" />
        </IonList>
      </DataSource>
    </IonContent>
  </AppView>
</template>
