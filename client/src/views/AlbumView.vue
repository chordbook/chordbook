<script setup>
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import { album as placeholderIcon } from '@/icons'

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
      :src="`albums/${id}`"
    >
      <Head>
        <title v-if="data">
          {{ data.title }} by {{ data.artist.name }}
        </title>
      </Head>
      <ion-header
        translucent
        collapse="fade"
      >
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-back-button
              v-if="data?.artist"
              text=""
              :default-href="`/artists/${data.artist.id}`"
            />
          </ion-buttons>
          <ion-title>{{ data?.title }}</ion-title>
          <ion-buttons slot="end">
            <add-to-library-button :id="id" />
          </ion-buttons>
        </ion-toolbar>
      </ion-header>

      <ion-content
        fullscreen
        class="main-content"
      >
        <div class="ion-padding flex gap-4 md:gap-6 lg:gap-8 flex-col md:flex-row">
          <div class="flex place-content-center md:block md:place-content-start">
            <div
              class="aspect-square w-3/4 md:w-60 rounded overflow-hidden shadow-lg flex place-content-center items-center bg-slate-100 dark:bg-slate-800"
            >
              <img
                v-if="data?.cover?.large"
                :src="data.cover.large"
              >
              <ion-icon
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
            <ion-label
              v-if="data?.artist"
              button
              :router-link="{ name: 'artist', params: { id: data.artist.id } }"
              class="block text-xl md:text-2xl text-teal-500 ion-activatable ion-focusable"
            >
              {{ data.artist.name }}
            </ion-label>
            <ion-note class="text-xs uppercase font-semibold">
              <ion-label
                v-if="data?.genre"
                :router-link="{ name: 'genre', params: { id: data.genre.id } }"
              >
                {{ data.genre.name }}
              </ion-label>
              •
              {{ data?.released }}
            </ion-note>

            <ion-note
              class="block text-sm line-clamp-3 overflow-hidden mt-4"
              onclick="this.classList.toggle('line-clamp-3')"
            >
              {{ data?.description }}
            </ion-note>
          </div>
        </div>

        <ion-list v-if="data?.tracks && data.tracks.length > 0">
          <ion-item
            v-for="track in data.tracks"
            :key="track.id"
            :href="`/tracks/${track.id}`"
            :class="{'text-neutral-500/50 hover:text-current transition-opacity': !track.has_songsheet}"
          >
            <ion-text slot="start">
              <span class="text-sm text-muted w-4 text-right inline-block">{{ track.number }}</span>
            </ion-text>
            <ion-label>
              <h2>{{ track.title }}</h2>
            </ion-label>
          </ion-item>
        </ion-list>
      </ion-content>
    </data-source>
  </app-view>
</template>
