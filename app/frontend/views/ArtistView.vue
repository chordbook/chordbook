<template>
  <ion-page>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/artists" />
        </ion-buttons>
        <ion-title>{{ artist.name }}</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <div
        :style="`background-image: linear-gradient(rgba(0,0,0,0) 33%, rgba(0,0,0,0.8)), url(${artist.banner});`"
        class="ion-padding bg-cover bg-center bg-top aspect-4/3 max-h-screen-3/4 w-full flex flex-col place-content-end text-white text-shadow"
      >
        <h2 class="opacity-80">
          <router-link
            v-if="artist.genre"
            :to="{ name: 'genre', params: { id: artist.genre.id } }"
          >
            {{ artist.genre.name }}
          </router-link>
        </h2>
        <h1 class="text-4xl font-bold">
          {{ artist.name }}
        </h1>
      </div>

      <ion-list v-if="tracks.length > 0">
        <ion-list-header>
          <ion-label>Top Songs</ion-label>
          <ion-button>See All</ion-button>
        </ion-list-header>

        <div
          class="columns-3 overflow-x-auto"
          style="column-width: 95vw"
        >
          <track-item
            v-for="track in tracks"
            :key="track.id"
            :track="track"
          />
        </div>
      </ion-list>

      <ion-list v-if="albums.length > 0">
        <ion-list-header>
          <ion-label>Top Albums</ion-label>
          <ion-button>See All</ion-button>
        </ion-list-header>

        <album-item
          v-for="album in albums"
          :key="album.id"
          :album="album"
        />
      </ion-list>

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
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonButton } from '@ionic/vue'
import TrackItem from '@/components/TrackItem.vue'
import AlbumItem from '@/components/AlbumItem.vue'

export default {
  components: { TrackItem, AlbumItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonButton },

  data () {
    return {
      artist: {},
      tracks: [],
      albums: []
    }
  },

  watch: {
    $route: 'fetchData'
  },

  created () {
    this.fetchData()
  },

  calculated: {
    classList () {
      const columns = Math.ceil(this.tracks.length / 4)
      const classes = `overflow-x-auto columns-${columns}`
      return {
        [classes]: columns > 0
      }
    }
  },

  methods: {
    async fetchData () {
      const id = this.$route.params.id

      return client.get(`/api/artists/${id}.json`).then(response => {
        this.artist = response.data

        client.get(`/api/artists/${id}/albums.json`).then(response => {
          this.albums = response.data
        })

        client.get(`/api/artists/${id}/tracks.json`).then(response => {
          this.tracks = response.data
        })

        client.get(`/api/artists/${id}/songsheets.json`).then(response => {
          this.songsheets = response.data
        })
      })
    }
  }
}
</script>
