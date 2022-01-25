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
        <ion-title>Artists</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Artists
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list>
        <artist-item
          v-for="artist in artists"
          :key="artist.id"
          :artist="artist"
        />
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import ArtistItem from '@/components/ArtistItem.vue'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList } from '@ionic/vue'

export default {
  components: { ArtistItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList },

  data () {
    return {
      artists: []
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
      this.artists = (await client.get('/api/artists.json', { params: this.$route.query })).data
    }
  }

}
</script>
