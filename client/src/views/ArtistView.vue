<script setup>
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import ModelList from '@/components/ModelList.vue'

defineProps({
  id: {
    type: String,
    required: true
  }
})
</script>

<template>
  <app-view>
    <data-source
      v-slot="{ data }"
      :src="`artists/${id}`"
    >
      <ion-header
        translucent
        collapse="fade"
      >
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-back-button
              text=""
              default-href="/artists"
            />
          </ion-buttons>
          <ion-title>{{ data?.name }}</ion-title>
          <ion-buttons slot="end">
            <add-to-library-button :id="id" />
          </ion-buttons>
        </ion-toolbar>
      </ion-header>

      <ion-content fullscreen>
        <ion-header>
          <div
            :style="`background-image: linear-gradient(rgba(0,0,0,0) 33%, rgba(0,0,0,0.8)), url(${data?.banner}); background-position: 50% 25%`"
            class="bg-slate-700 bg-cover aspect-16/9-max-h-screen-1/2"
          >
            <ion-toolbar class="absolute bottom-0 w-full ion-padding text-white text-shadow">
              <ion-note
                v-if="data?.genre"
                button
                :router-link="{ name: 'genre', params: { id: data?.genre.id } }"
                class="block text-lg text-white opacity-70 ion-activatable ion-focusable"
              >
                {{ data?.genre.name }}
              </ion-note>
              <h1 class="text-4xl font-bold m-0">
                {{ data?.name }}
              </h1>
            </ion-toolbar>
          </div>
        </ion-header>

        <data-source
          v-slot="{ data: tracks }"
          :src="`artists/${id}/tracks`"
        >
          <ion-list v-if="tracks?.length > 0">
            <ion-list-header>
              <ion-label>Top Songs</ion-label>
              <ion-button :router-link="{ name: 'artist.tracks', params: { id } }">
                See All
              </ion-button>
            </ion-list-header>

            <model-list :items="tracks" />
          </ion-list>
        </data-source>

        <data-source
          v-slot="{ data: albums }"
          :src="`artists/${id}/albums`"
        >
          <ion-list
            v-if="albums?.length > 0"
            lines="none"
          >
            <ion-list-header>
              <ion-label>Top Albums</ion-label>
              <ion-button :router-link="{ name: 'artist.albums', params: { id } }">
                See All
              </ion-button>
            </ion-list-header>

            <model-list
              :items="albums"
              format="card"
              :show-artist="false"
            />
          </ion-list>
        </data-source>

        <div v-if="data?.biography">
          <ion-list-header>
            <ion-label>About</ion-label>
          </ion-list-header>
          <div class="ion-padding">
            <p
              class="text-sm line-clamp-6 overflow-hidden"
              onclick="this.classList.toggle('line-clamp-6')"
            >
              {{ data?.biography }}
            </p>
          </div>
        </div>
      </ion-content>
    </data-source>
  </app-view>
</template>

<style scoped>
ion-content ion-toolbar {
  --background: transparent;
}
</style>
