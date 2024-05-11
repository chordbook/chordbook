<script setup>
import { modalController } from "@ionic/vue";
import SongsheetItem from "@/components/SongsheetItem.vue";

defineProps({
  id: {
    type: String,
    required: true,
  },
  exclude: {
    type: String,
    default: null,
  },
});
</script>

<template>
  <ion-modal can-dismiss :breakpoints="[0.5, 1]" :initial-breakpoint="0.5">
    <app-view>
      <ion-header>
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-button role="cancel" @click="modalController.dismiss()">
              Cancel
            </ion-button>
          </ion-buttons>
          <ion-title>Alternate Versions</ion-title>
        </ion-toolbar>
      </ion-header>
      <ion-content>
        <ion-list>
          <data-source v-slot="{ items }" :src="`tracks/${id}/songsheets`">
            <template v-for="version in items" :key="version.id">
              <songsheet-item
                v-if="version.id !== exclude"
                v-bind="version"
                router-direction="replace"
                @click="modalController.dismiss()"
              />
            </template>
          </data-source>
        </ion-list>
      </ion-content>
    </app-view>
  </ion-modal>
</template>
