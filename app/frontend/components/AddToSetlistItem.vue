<template>
  <ion-item
    id="add-songsheet-to-setlist"
    button
    :detail-icon="icons.setlist"
  >
    <ion-label>Add to Setlist…</ion-label>
  </ion-item>
  <Modal
    :songsheet="songsheet"
    trigger="add-songsheet-to-setlist"
  />
</template>

<script setup>
import * as icons from '@/icons'
import { IonItem, IonLabel } from '@ionic/vue'
import Modal from '@/components/AddToSetlistModal.vue'
import { defineProps } from 'vue'

defineProps({
  songsheet: {
    type: Object,
    required: true
  }
})
</script>
