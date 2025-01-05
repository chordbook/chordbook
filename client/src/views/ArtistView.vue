<script setup lang="ts">
import type { ArtistFull } from "@/api";
import AddToLibraryButton from "../components/AddToLibraryButton.vue";

defineProps<{
  id: string;
}>();
</script>

<template>
  <AppView>
    <DataSource v-slot="{ data }: { data: ArtistFull }" :src="`artists/${id}`">
      <Head>
        <title v-if="data">
          {{ data.name }}
        </title>
      </Head>
      <IonHeader translucent collapse="fade">
        <IonToolbar>
          <IonButtons slot="start">
            <IonBackButton text="" default-href="/artists" />
          </IonButtons>
          <IonTitle>{{ data?.name }}</IonTitle>
          <IonButtons slot="end">
            <AddToLibraryButton :id="id" />
          </IonButtons>
        </IonToolbar>
      </IonHeader>

      <IonContent fullscreen>
        <IonHeader>
          <div
            :style="`background-image: linear-gradient(rgba(0,0,0,0) 33%, rgba(0,0,0,0.8)), url(${data?.banner}); background-position: 50% 25%`"
            class="bg-slate-700 bg-cover aspect-16/9-max-h-screen-1/2"
          >
            <IonToolbar
              class="absolute bottom-0 w-full ion-padding main-content text-white text-shadow"
            >
              <IonNote
                v-if="data?.genre"
                button
                :router-link="{ name: 'genre', params: { id: data?.genre.id } }"
                class="block text-lg text-white opacity-70 ion-activatable ion-focusable"
              >
                {{ data?.genre.name }}
              </IonNote>
              <h1 class="text-4xl font-bold m-0">
                {{ data?.name }}
              </h1>
            </IonToolbar>
          </div>
        </IonHeader>

        <div class="main-content">
          <DataSource v-slot="{ data: tracks }" :src="`artists/${id}/tracks`">
            <IonList v-if="tracks?.length > 0">
              <IonListHeader>
                <IonLabel>Top Songs</IonLabel>
                <IonButton :router-link="{ name: 'artist.tracks', params: { id } }">
                  See All
                </IonButton>
              </IonListHeader>

              <ModelList :items="tracks" />
            </IonList>
          </DataSource>

          <DataSource v-slot="{ data: albums }" :src="`artists/${id}/albums`">
            <IonList v-if="albums?.length > 0" lines="none">
              <IonListHeader>
                <IonLabel>Top Albums</IonLabel>
                <IonButton :router-link="{ name: 'artist.albums', params: { id } }">
                  See All
                </IonButton>
              </IonListHeader>

              <ModelList :items="albums" format="card" :show-artist="false" />
            </IonList>
          </DataSource>

          <div v-if="data?.biography">
            <IonListHeader>
              <IonLabel>About</IonLabel>
            </IonListHeader>
            <div class="ion-padding">
              <p
                class="text-sm line-clamp-6 overflow-hidden"
                onclick="this.classList.toggle('line-clamp-6')"
              >
                {{ data?.biography }}
              </p>
            </div>
          </div>
        </div>
      </IonContent>
    </DataSource>
  </AppView>
</template>

<style scoped>
ion-content ion-toolbar {
  --background: transparent;
}
</style>
