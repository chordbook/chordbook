<script setup>
import {
  modalController,
  toastController
} from '@ionic/vue'
import SetlistItem from '@/components/SetlistItem.vue'
import NewSetlistModal from '@/components/NewSetlistModal.vue'
import DataSource from '@/DataSource'
import client from '@/client'
import { defineProps, onMounted } from 'vue'

const props = defineProps({
  songsheet: {
    type: Object,
    required: true
  }
})

const dataSource = new DataSource('setlists.json')

onMounted(() => dataSource.load())

async function add (setlist) {
  await client.post(`setlists/${setlist.id}/items.json`, { id: props.songsheet.id })

  modalController.dismiss()

  return (await toastController.create({
    message: `Added to ${setlist.title}`,
    duration: 3000
  })).present()
}

async function newModal () {
  const modal = await modalController.create({ component: NewSetlistModal })
  modal.onDidDismiss().then(({ data }) => {
    if (data) add(data)
  })
  return modal.present()
}
</script>

<template>
  <ion-modal ref="modal">
    <authenticated>
      <ion-header>
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-button
              role="cancel"
              @click="modalController.dismiss()"
            >
              Cancel
            </ion-button>
          </ion-buttons>
          <ion-title>Add to Setlist</ion-title>
          <ion-buttons slot="end">
            <ion-button
              role="cancel"
              @click="newModal()"
            >
              New setlist
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
    </authenticated>
  </ion-modal>
</template>
