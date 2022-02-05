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
          v-for="artist in dataSource.items"
          :key="artist.id"
          :artist="artist"
        />
      </ion-list>

      <ion-infinite-scroll
        :disabled="dataSource.loading || dataSource.disabled"
        @ion-infinite="dataSource.load().then(() => $event.target.complete())"
      >
        <ion-infinite-scroll-content
          loading-spinner="bubbles"
          loading-text="Loading…"
        />
      </ion-infinite-scroll>
    </ion-content>
  </ion-page>
</template>

<script>
import DataSource from '@/DataSource'
import ArtistItem from '@/components/ArtistItem.vue'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonButtons, IonMenuToggle, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent } from '@ionic/vue'

export default {
  components: { ArtistItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonButtons, IonMenuToggle, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent },

  data () {
    const dataSource = new DataSource('/api/artists.json', { params: this.$route.query })

    return { dataSource }
  },

  ionViewWillEnter () {
    this.dataSource.load()
  }
}
</script>
