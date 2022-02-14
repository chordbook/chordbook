<script>
import DataSource from '@/DataSource'
import client from '@/client'
import SongsheetItem from '@/components/SongsheetItem.vue'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonList, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent, IonItemSliding, IonItemOptions, IonItemOption, toastController, IonPopover, IonButton, IonIcon, IonLabel, IonItem, actionSheetController, IonReorderGroup } from '@ionic/vue'
import * as icons from '@/icons'
import { trash } from 'ionicons/icons'

export default {
  components: { SongsheetItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonList, IonBackButton, IonInfiniteScroll, IonInfiniteScrollContent, IonItemSliding, IonItemOptions, IonItemOption, IonPopover, IonButton, IonIcon, IonLabel, IonItem, IonReorderGroup },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data () {
    const dataSource = new DataSource(`/api/setlists/${this.id}/items.json`, { params: this.$route.query })
    return {
      dataSource,
      setlist: {},
      icons,
      editing: false
    }
  },

  created () {
    client.get(`/api/setlists/${this.id}.json`).then(response => {
      this.setlist = response.data
    })

    this.dataSource.load()
  },

  methods: {
    async reorder (e) {
      const songsheet = this.dataSource.items[e.detail.from]

      await client.patch(`/api/setlists/${this.id}/items/${songsheet.id}.json`, {
        item: { position: e.detail.to + 1 }
      })

      e.detail.complete(true)
    },

    async remove (songsheet) {
      await client.delete(`/api/setlists/${this.id}/items/${songsheet.id}.json`)
      this.dataSource.items.splice(this.dataSource.items.indexOf(songsheet), 1)
      return (await toastController.create({
        message: `${songsheet.title} was removed from ${this.setlist.title}`,
        duration: 3000
      })).present()
    },

    async destroy () {
      const actionSheet = await actionSheetController
        .create({
          header: 'Are you sure you want to delete this setlist?',
          buttons: [
            {
              text: 'Delete setlist',
              role: 'destructive',
              icon: trash,
              handler: async () => {
                await client.delete(`/api/setlists/${this.id}.json`)
                this.$router.back({ name: 'setlists' })
              }
            },
            { text: 'Cancel', icon: close, role: 'cancel' }
          ]
        })
      await actionSheet.present()
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

        <ion-buttons slot="end">
          <ion-button
            v-show="editing"
            @click="editing = false"
          >
            Done
          </ion-button>
          <ion-button
            v-show="!editing"
            :id="`setlist-context-${setlist.id}`"
          >
            <ion-icon
              slot="icon-only"
              size="small"
              :ios="icons.iosEllipsis"
              :md="icons.mdEllipsis"
            />
          </ion-button>
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
        <ion-reorder-group
          :disabled="!editing"
          @ion-item-reorder="reorder"
        >
          <ion-item-sliding
            v-for="songsheet in dataSource.items"
            :key="songsheet.id"
          >
            <ion-item-options side="end">
              <ion-item-option
                color="danger"
                @click="remove(songsheet)"
              >
                Remove
              </ion-item-option>
            </ion-item-options>

            <songsheet-item
              :songsheet="songsheet"
            >
              <!-- <ion-reorder slot="end"></ion-reorder> -->
            </songsheet-item>
          </ion-item-sliding>
        </ion-reorder-group>
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

    <ion-popover
      :trigger="`setlist-context-${setlist.id}`"
      dismiss-on-select
    >
      <ion-list>
        <ion-item
          button
          @click="editing = true"
        >
          <ion-label>Edit</ion-label>
        </ion-item>
        <ion-item
          button
          :detail-icon="icons.createOutline"
          @click="destroy"
        >
          <ion-label>Delete</ion-label>
        </ion-item>
      </ion-list>
    </ion-popover>
  </ion-page>
</template>
