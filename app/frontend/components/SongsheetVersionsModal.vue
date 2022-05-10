<script setup>
import { defineProps } from 'vue'
import {
  IonModal,
  IonList,
  IonHeader,
  IonToolbar,
  IonButtons,
  IonButton,
  IonTitle,
  IonContent,
  modalController
} from '@ionic/vue'
import SongsheetItem from '@/components/SongsheetItem.vue'

defineProps({
  versions: {
    type: Array,
    default () { return [] }
  }
})
</script>

<template>
  <ion-modal
    can-dismiss
    :breakpoints="[0.25, 0.5, 1]"
    :initial-breakpoint="0.25"
  >
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
        <ion-title>Alternate Versions</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <ion-list>
        <songsheet-item
          v-for="version in versions"
          :key="version.id"
          :songsheet="version"
          @click="modalController.dismiss()"
        />
      </ion-list>
    </ion-content>
  </ion-modal>
</template>
