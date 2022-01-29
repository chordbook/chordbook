<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/discover"
          />
        </ion-buttons>
        <ion-title>{{ track.title }}</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <div class="flex flex-col place-items-center mb-6">
        <img
          :src="track.album?.thumbnail"
          class="aspect-square w-3/4 m-4 rounded overflow-hidden shadow-lg"
        >
        <h1 class="text-2xl">
          {{ track.title }}
        </h1>
        <h2 class="text-xl text-blue-500">
          <router-link
            v-if="track.artist"
            :to="{ name: 'artist', params: { id: track.artist.id } }"
          >
            {{ track.artist.name }}
          </router-link>
        </h2>
      </div>

      <ion-list>
        <ion-list-header>Versions</ion-list-header>

        <ion-item
          v-for="(songsheet, index) in track.songsheets"
          :key="songsheet.id"
          :router-link="{ name: 'songsheet', params: { id: songsheet.id } }"
        >
          <ion-text slot="start">
            <span class="text-sm opacity-50">{{ index + 1 }}</span>
          </ion-text>
          <ion-label>
            {{ track.title }}
            <p>Updated {{ formatDate(track.updated_at) }}</p>
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
          {{ track.metadata?.strDescriptionEN }}
        </p>
      </div>
    </ion-content>
  </ion-page>
</template>

<script>
import { IonPage, IonContent, IonHeader, IonBackButton, IonButtons, IonToolbar, IonTitle, IonList, IonLabel, IonItem, IonListHeader, IonText } from '@ionic/vue'
import client from '@/client'

export default {
  components: { IonPage, IonContent, IonHeader, IonBackButton, IonButtons, IonToolbar, IonTitle, IonList, IonLabel, IonItem, IonListHeader, IonText },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      track: {}
    }
  },

  async ionViewWillEnter () {
    this.track = (await client.get(`/api/tracks/${this.id}.json`)).data
    if (this.track.songsheets.length === 1) {
      this.$router.push({ name: 'songsheet', params: { id: this.track.songsheets[0].id }, replace: true })
    } else if (this.track.songsheets.length === 0) {
      this.$router.push({ name: 'songsheet.new', params: { track: this.track.id }, replace: true })
    }
  },

  methods: {
    formatDate (input) {
      const date = new Date(input)
      return new Intl.DateTimeFormat().format(date)
    }
  }
}
</script>
