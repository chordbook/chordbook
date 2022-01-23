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
            :default-href="`/artists/${album.artist.id}`"
          />
        </ion-buttons>
        <ion-title />
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <div class="flex flex-col place-items-center mb-6">
        <img
          :src="album.thumbnail"
          class="aspect-square w-3/4 m-4 rounded overflow-hidden shadow-lg"
        >
        <h1 class="text-2xl">
          {{ album.title }}
        </h1>
        <h2 class="text-xl text-blue-500">
          <router-link
            v-if="album.artist"
            :to="{ name: 'artist', params: { id: album.artist.id } }"
          >
            {{ album.artist.name }}
          </router-link>
        </h2>
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

      <ion-list-header>
        <ion-label>About</ion-label>
      </ion-list-header>
      <div class="ion-padding">
        <p
          class="text-sm line-clamp-6 overflow-hidden"
          onclick="this.classList.toggle('line-clamp-6')"
        >
          {{ album.description }}
        </p>
      </div>
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonItem, IonText } from '@ionic/vue'

export default {
  components: { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonItem, IonText },

  data () {
    return {
      album: {}
    }
  },

  watch: {
    $route: 'fetchData'
  },

  created () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      this.album = (await client.get(`/api/albums/${this.$route.params.id}.json`)).data
    }
  }
}
</script>
