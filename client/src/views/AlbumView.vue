<script setup lang="ts">
import type { AlbumFull } from "@/api";
import { album as placeholderIcon } from "@/icons";
import AddToLibraryButton from "../components/AddToLibraryButton.vue";

defineProps<{ id: string }>();
</script>

<template>
  <AppView>
    <DataSource v-slot="{ data }: { data: AlbumFull }" :src="`albums/${id}`">
      <Head>
        <title v-if="data">{{ data.title }} by {{ data.artist.name }}</title>
      </Head>
      <IonHeader translucent collapse="fade">
        <IonToolbar>
          <IonButtons slot="start">
            <IonBackButton
              v-if="data?.artist"
              text=""
              :default-href="`/artists/${data.artist.id}`"
            />
          </IonButtons>
          <IonTitle>{{ data?.title }}</IonTitle>
          <IonButtons slot="end">
            <AddToLibraryButton :id="id" />
          </IonButtons>
        </IonToolbar>
      </IonHeader>

      <IonContent fullscreen class="main-content">
        <div class="ion-padding flex gap-4 md:gap-6 lg:gap-8 flex-col md:flex-row">
          <div class="flex place-content-center md:block md:place-content-start">
            <div
              class="aspect-square w-3/4 md:w-60 rounded overflow-hidden shadow-lg flex place-content-center items-center bg-slate-100 dark:bg-slate-800"
            >
              <img v-if="data?.cover?.large" :src="data.cover.large" />
              <IonIcon
                v-else
                :icon="placeholderIcon"
                class="text-slate-300 dark:text-slate-700 text-6xl"
              />
            </div>
          </div>
          <div class="text-center md:text-left">
            <h1 class="text-xl md:text-3xl m-0">
              {{ data?.title }}
            </h1>
            <IonLabel
              v-if="data?.artist"
              button
              :router-link="{ name: 'artist', params: { id: data.artist.id } }"
              class="block text-xl md:text-2xl text-teal-500 ion-activatable ion-focusable"
            >
              {{ data.artist.name }}
            </IonLabel>
            <IonNote class="text-xs uppercase font-semibold">
              <IonLabel
                v-if="data?.genre"
                :router-link="{ name: 'genre', params: { id: data.genre.id } }"
              >
                {{ data.genre.name }}
              </IonLabel>
              •
              {{ data?.released }}
            </IonNote>

            <IonNote
              class="block text-sm line-clamp-3 overflow-hidden mt-4"
              onclick="this.classList.toggle('line-clamp-3')"
            >
              {{ data?.description }}
            </IonNote>
          </div>
        </div>

        <IonList v-if="data?.tracks && data.tracks.length > 0">
          <IonItem
            v-for="track in data.tracks"
            :key="track.id"
            :href="`/tracks/${track.id}`"
            :class="{
              'text-neutral-500/50 hover:text-current transition-opacity': !track.has_songsheet,
            }"
          >
            <IonText slot="start">
              <span class="text-sm text-muted w-4 text-right inline-block">{{ track.number }}</span>
            </IonText>
            <IonLabel>
              <h2>{{ track.title }}</h2>
            </IonLabel>
          </IonItem>
        </IonList>
      </IonContent>
    </DataSource>
  </AppView>
</template>
