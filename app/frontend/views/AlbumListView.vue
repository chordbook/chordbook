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
            :default-href="backLink"
          />
        </ion-buttons>
        <ion-title>Albums</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-list>
        <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8">
          <album-item
            v-for="album in dataSource.items"
            :key="album.id"
            :album="album"
          />
        </div>
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
import AlbumItem from '@/components/AlbumItem.vue'
import { IonPage, IonHeader, IonToolbar, IonButtons, IonBackButton, IonTitle, IonContent, IonList, IonInfiniteScroll, IonInfiniteScrollContent } from "@ionic/vue"

export default {
  components: { IonPage, IonHeader, IonToolbar, IonButtons, IonBackButton, IonTitle, IonContent, IonList, AlbumItem, IonInfiniteScroll, IonInfiniteScrollContent },

  data () {
    const dataSource = new DataSource(`/api${this.$route.path}`, { params: this.$route.query })

    return {
      dataSource
    }
  },

  computed: {
    backLink() {
      return this.$route.path.replace('/albums', '')
    }
  },

  created () {
    this.dataSource.load()
  }

}
</script>
