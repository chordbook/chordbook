<template>
  <ion-modal ref="root">
    <ion-header>
      <ion-toolbar>
        <ion-title>Add to Setlist</ion-title>
        <ion-buttons slot="end">
          <ion-button
            role="cancel"
            @click="dismiss()"
          >
            Cancel
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content class="ion-padding">
      <ion-list>
        <setlist-item
          v-for="setlist in dataSource.items"
          :key="setlist.id"
          :setlist="setlist"
          @click.prevent="add(setlist)"
        />
      </ion-list>
    </ion-content>
  </ion-modal>
</template>

<script>
import { IonContent, IonHeader, IonTitle, IonToolbar, IonList, IonButtons, IonButton, IonModal, toastController } from '@ionic/vue'
import SetlistItem from '@/components/SetlistItem.vue'
import DataSource from '@/DataSource'
import client from '@/client'

export default {
  components: { SetlistItem, IonContent, IonHeader, IonTitle, IonToolbar, IonList, IonButtons, IonButton, IonModal },

  props: {
    songsheet: {
      type: Object,
      required: true
    }
  },

  data () {
    const dataSource = new DataSource('/api/setlists.json')

    return {
      dataSource
    }
  },

  mounted () {
    this.dataSource.load()
  },

  methods: {
    add (setlist) {
      client.put(`/api/setlists/${setlist.id}/songsheets.json`, {
        songsheet: { id: this.songsheet.id }
      }).then(async response => {
        this.dismiss()
        return (await toastController.create({
          message: `Added to ${setlist.title}`,
          duration: 3000
        })).present()
      })
    },

    dismiss () {
      this.$el.dismiss()
    }
  }
}
</script>
