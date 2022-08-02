<script setup>
import { modalController } from '@ionic/vue'
import { useFetch } from '@/client'
import { ref } from 'vue'

const params = ref({})

async function save () {
  const response = await useFetch('setlists.json').post({ setlist: params.value })
  modalController.dismiss(response.data)
}
</script>

<template>
  <ion-header>
    <ion-toolbar>
      <ion-title>New Setlist</ion-title>
      <ion-buttons slot="start">
        <ion-button
          role="cancel"
          @click="modalController.dismiss()"
        >
          Cancel
        </ion-button>
      </ion-buttons>
    </ion-toolbar>
  </ion-header>
  <ion-content>
    <ion-item>
      <ion-label position="stacked">
        Setlist title
      </ion-label>
      <ion-input v-model="params.title" />
    </ion-item>

    <ion-item>
      <ion-label position="stacked">
        Description
      </ion-label>
      <ion-textarea v-model="params.description" />
    </ion-item>

    <div class="ion-padding">
      <ion-button
        expand="block"
        type="submit"
        @click="save"
      >
        Save
      </ion-button>
    </div>
  </ion-content>
</template>
