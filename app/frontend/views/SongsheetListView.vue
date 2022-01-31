<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Songs</ion-title>
        <ion-buttons slot="end">
          <ion-button :router-link="{ name: 'songsheet.new' }">
            <ion-icon
              slot="icon-only"
              :icon="icons.add"
            />
          </ion-button>
        </ion-buttons>
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
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonList, IonButton, IonIcon } from '@ionic/vue'
import { add } from 'ionicons/icons'

export default {
  components: { SongsheetItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonList, IonButton, IonIcon },

  data () {
    return {
      songsheets: [],
      icons: { add }
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
