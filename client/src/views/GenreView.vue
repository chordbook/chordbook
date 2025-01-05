<script setup lang="ts">
import type { Album, Artist, Genre, Track } from "@/api";
defineProps<{ id: string }>();
</script>

<template>
  <AppView>
    <DataSource v-slot="{ data: genre }: { data: Genre }" :src="`genres/${id}`">
      <Head>
        <title>
          {{ genre.name }}
        </title>
      </Head>
      <IonHeader translucent>
        <IonToolbar>
          <IonButtons slot="start">
            <IonBackButton text="" default-href="/discover" />
          </IonButtons>
          <IonTitle>{{ genre.name }}</IonTitle>
        </IonToolbar>
      </IonHeader>

      <IonContent fullscreen class="main-content">
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">
              {{ genre.name }}
            </IonTitle>
          </IonToolbar>
        </IonHeader>

        <IonList>
          <IonListHeader>
            <IonLabel>Top Songs</IonLabel>
            <IonButton :router-link="{ name: 'genre.tracks', params: { id } }"> See All </IonButton>
          </IonListHeader>

          <DataSource v-slot="{ data }: { data: Track[] }" :src="`genres/${id}/tracks`">
            <ModelList :items="data" />
          </DataSource>
        </IonList>

        <IonList>
          <IonListHeader>
            <IonLabel>Top Artists</IonLabel>
            <IonButton :router-link="{ name: 'genre.artists', params: { id } }">
              See All
            </IonButton>
          </IonListHeader>

          <DataSource v-slot="{ data }: { data: Artist[] }" :src="`genres/${id}/artists`">
            <ModelList :items="data" format="card" />
          </DataSource>
        </IonList>

        <IonList>
          <IonListHeader>
            <IonLabel>Top Albums</IonLabel>
            <IonButton :router-link="{ name: 'genre.albums', params: { id } }"> See All </IonButton>
          </IonListHeader>

          <DataSource v-slot="{ data }: { data: Album[] }" :src="`genres/${id}/albums`">
            <ModelList :items="data" format="card" />
          </DataSource>
        </IonList>
      </IonContent>
    </DataSource>
  </AppView>
</template>
