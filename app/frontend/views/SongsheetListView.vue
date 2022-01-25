<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/library"
          />
        </ion-buttons>
        <ion-title>Songs</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Songs
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list>
        <songsheet-item
          v-for="songsheet in songsheets"
          :key="songsheet.id"
          :songsheet="songsheet"
        />
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import SongsheetItem from '@/components/SongsheetItem.vue'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList } from '@ionic/vue'

export default {
  components: { SongsheetItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList },

  data () {
    return {
      songsheets: []
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
      this.songsheets = (await client.get('/api/songsheets.json', { params: this.$route.query })).data
    }
  }

}
</script>
