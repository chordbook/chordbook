<script>
import DataSource from '@/DataSource'
import client from '@/client'
import SongsheetItem from '@/components/SongsheetItem.vue'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonList, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent, IonItemSliding, IonItemOptions, IonItemOption, toastController } from '@ionic/vue'

export default {
  components: { SongsheetItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonList, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent, IonItemSliding, IonItemOptions, IonItemOption },

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
  },

  methods: {
    async remove (songsheet) {
      await client.delete(`/api/setlists/${this.id}/songsheets/${songsheet.id}.json`)
      this.dataSource.items.splice(this.dataSource.items.indexOf(songsheet), 1)
      return (await toastController.create({
        message: `${songsheet.title} was removed from ${this.setlist.title}`,
        duration: 3000
      })).present()
    }
  }
}
</script>

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
        <ion-item-sliding
          v-for="songsheet in dataSource.items"
          :key="songsheet.id"
        >
          <ion-item-options side="end">
            <ion-item-option color="danger" @click="remove(songsheet)">Remove</ion-item-option>
          </ion-item-options>

          <songsheet-item
            :songsheet="songsheet"
          />
        </ion-item-sliding>
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
