<script setup>
import * as icons from '@/icons'
import Modal from '@/components/AddToSetlistModal.vue'
import { defineProps } from 'vue'

defineProps({
  songsheet: {
    type: Object,
    required: true
  }
})
</script>

<template>
  <ion-item
    id="add-songsheet-to-setlist"
    button
    detail
    :detail-icon="icons.setlist"
  >
    <ion-label>Add to Setlist…</ion-label>
  </ion-item>
  <Modal
    :songsheet="songsheet"
    trigger="add-songsheet-to-setlist"
  />
</template>
