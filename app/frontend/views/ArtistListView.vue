<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Artists</ion-title>

        <ion-buttons slot="start">
          <ion-back-button
            class="md:hidden"
            text="Library"
            :default-href="backLink"
          />
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
        threshold="500px"
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
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonButtons, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent } from '@ionic/vue'

export default {
  components: { ArtistItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonButtons, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent },

  data () {
    const dataSource = new DataSource(`/api${this.$route.path}`, { params: this.$route.query })

    return { dataSource }
  },

  computed: {
    backLink () {
      return this.$route.path.replace('/artists', '') || '/library'
    }
  },

  created () {
    this.dataSource.load()
  }
}
</script>
