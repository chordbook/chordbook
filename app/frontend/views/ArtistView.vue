<template>
  <ion-page>
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
        <ion-title>{{ artist.name }}</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <ion-header collapse="condense">
        <div
          :style="`background-image: linear-gradient(rgba(0,0,0,0) 33%, rgba(0,0,0,0.8)), url(${artist.banner});`"
          class="bg-slate-700 bg-cover bg-center aspect-16/9-max-h-screen-1/2"
        >
          <ion-toolbar class="absolute bottom-0 w-full ion-padding text-white text-shadow">
            <ion-note
              v-if="artist.genre"
              button
              :router-link="{ name: 'genre', params: { id: artist.genre.id } }"
              class="block text-lg text-white opacity-60 ion-activatable ion-focusable"
            >
              {{ artist.genre.name }}
            </ion-note>
            <h1 class="text-4xl font-bold m-0">
              {{ artist.name }}
            </h1>
          </ion-toolbar>
        </div>
      </ion-header>

      <ion-list v-if="tracks.length > 0">
        <ion-list-header>
          <ion-label>Top Songs</ion-label>
          <ion-button :router-link="{ name: 'artist.tracks', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4">
          <track-item
            v-for="track in tracks"
            :key="track.id"
            :track="track"
          />
        </div>
      </ion-list>

      <ion-list
        v-if="albums.length > 0"
        lines="none"
      >
        <ion-list-header>
          <ion-label>Top Albums</ion-label>
          <ion-button :router-link="{ name: 'artist.albums', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 2xl:auto-cols-1/6">
          <album-item
            v-for="album in albums"
            :key="album.id"
            :album="album"
            :show-artist="false"
          />
        </div>
      </ion-list>

      <div v-if="artist.biography">
        <ion-list-header>
          <ion-label>About</ion-label>
        </ion-list-header>
        <div class="ion-padding">
          <p
            class="text-sm line-clamp-6 overflow-hidden"
            onclick="this.classList.toggle('line-clamp-6')"
          >
            {{ artist.biography }}
          </p>
        </div>
      </div>
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonButton, IonNote } from '@ionic/vue'
import TrackItem from '@/components/TrackItem.vue'
import AlbumItem from '@/components/AlbumItem.vue'

export default {
  components: { TrackItem, AlbumItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonButton, IonNote },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      artist: {},
      tracks: [],
      albums: []
    }
  },

  ionViewWillEnter () {
    return this.fetchData()
  },

  methods: {
    async fetchData () {
      return Promise.all([
        client.get(`artists/${this.id}.json`).then(response => {
          this.artist = response.data
        }),
        client.get(`artists/${this.id}/albums.json`).then(response => {
          this.albums = response.data
        }),
        client.get(`artists/${this.id}/tracks.json`).then(response => {
          this.tracks = response.data
        })
      ])
    }
  }
}
</script>

<style scoped>
/* Safari does not respect max-height with aspect-ratio, so workaround it */
.aspect-16\/9-max-h-screen-1\/2 {
  @apply max-h-screen-1/2 overflow-hidden relative;
}
.aspect-16\/9-max-h-screen-1\/2:before {
  content: '';
  @apply block aspect-16/9;
}

ion-content ion-toolbar {
  --background: transparent
}
</style>
