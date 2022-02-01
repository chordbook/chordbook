<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Artists</ion-title>

        <ion-buttons slot="start">
          <ion-menu-toggle>
            <ion-back-button
              text=""
              type="reset"
              default-href=""
            />
          </ion-menu-toggle>
        </ion-buttons>
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
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonButtons, IonMenuToggle, IonBackButton } from '@ionic/vue'

export default {
  components: { ArtistItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonButtons, IonMenuToggle, IonBackButton },

  data () {
    return {
      artists: []
    }
  },

  ionViewWillEnter () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      this.artists = (await client.get('/api/artists.json', { params: this.$route.query })).data
    }
  }

}
</script>
