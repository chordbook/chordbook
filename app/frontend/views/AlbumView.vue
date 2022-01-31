<template>
  <ion-page>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            v-if="album.artist"
            text=""
            :default-href="`/artists/${album.artist.id}`"
          />
        </ion-buttons>
        <ion-title />
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <div class="ion-padding ion-margin flex gap-4 md:gap-6 flex-col md:flex-row">
        <div class="text-center flex-shrink-0">
          <ion-img
            :src="album.thumbnail"
            class="aspect-square w-3/4 md:w-60 rounded overflow-hidden shadow-lg"
          />
        </div>
        <div class="text-center md:text-left md:pt-6">
          <h1 class="text-xl md:text-3xl m-0">
            {{ album.title }}
          </h1>
          <ion-label
            v-if="album.artist"
            button
            router-link="{ name: 'artist', params: { id: album.artist.id } }"
            class="block text-xl md:text-2xl text-blue-500 ion-activatable ion-focusable"
          >
            {{ album.artist.name }}
          </ion-label>
          <ion-note class="text-xs uppercase font-semibold">
            <ion-label
              v-if="album.genre"
              :router-link="{ name: 'genre', params: { id: album.genre.id } }"
            >
              {{ album.genre?.name }}
            </ion-label>
            •
            {{ album.released }}
          </ion-note>

          <ion-note
            class="block text-sm line-clamp-3 overflow-hidden mt-4"
            onclick="this.classList.toggle('line-clamp-3')"
          >
            {{ album.description }}
          </ion-note>
        </div>
      </div>

      <ion-list v-if="album.tracks && album.tracks.length > 0">
        <ion-item
          v-for="track in album.tracks"
          :key="track.id"
          :href="`/tracks/${track.id}`"
        >
          <ion-text slot="start">
            <span class="text-sm opacity-50">{{ track.number }}</span>
          </ion-text>
          <ion-label>
            <h2>{{ track.title }}</h2>
          </ion-label>
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonLabel, IonItem, IonText, IonNote, IonImg } from '@ionic/vue'

export default {
  components: { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonLabel, IonItem, IonText, IonNote, IonImg },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      album: {}
    }
  },

  ionViewWillEnter () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      this.album = (await client.get(`/api/albums/${this.id}.json`)).data
    }
  }
}
</script>
