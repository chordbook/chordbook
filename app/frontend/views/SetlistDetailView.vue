<template>
  <ion-page>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-title>{{ setlist.title }}</ion-title>

        <ion-buttons slot="start">
          <ion-back-button
            text="Setlists"
            :default-href="{ name: 'setlists' }"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title>{{ setlist.title }}</ion-title>
        </ion-toolbar>
      </ion-header>

      <p class="ion-padding">
        {{ setlist.description }}
      </p>

      <ion-list>
        <songsheet-item
          v-for="songsheet in dataSource.items"
          :key="songsheet.id"
          :songsheet="songsheet"
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
import client from '@/client'
import SongsheetItem from '@/components/SongsheetItem.vue'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonList, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent } from '@ionic/vue'

export default {
  components: { SongsheetItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonList, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data () {
    const dataSource = new DataSource(`/api/setlists/${this.id}/songsheets.json`, { params: this.$route.query })
    return {
      dataSource,
      setlist: {}
    }
  },

  created () {
    client.get(`/api/setlists/${this.id}.json`).then(response => {
      this.setlist = response.data
    })

    this.dataSource.load()
  }
}
</script>
