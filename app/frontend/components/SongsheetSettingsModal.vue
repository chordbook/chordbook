<script setup>
import { defineProps } from 'vue'
import {
  IonItem,
  IonLabel,
  IonList,
  IonModal,
  IonSelect,
  IonSelectOption,
  IonToggle,
  IonSegment,
  IonSegmentButton
} from '@ionic/vue'
import TransposeControl from '@/components/TransposeControl.vue'
import useSongsheetSettings from '@/stores/songsheet-settings'

const instruments = ['Guitar', 'Ukulele']
const settings = useSongsheetSettings()

defineProps({
  note: {
    type: String,
    required: true
  }
})
</script>

<template>
  <ion-modal
    can-dismiss
    :breakpoints="[1]"
    :initial-breakpoint="1"
    style="--height:max-content"
  >
    <div class="ion-padding-vertical">
      <h5 class="ion-padding-horizontal">
        Transpose
      </h5>

      <ion-list>
        <transpose-control
          :note="note"
          @update="(v) => settings.transpose = v"
        />
      </ion-list>

      <h5 class="ion-padding-horizontal">
        Chords
      </h5>

      <ion-list>
        <ion-item>
          <ion-label>Instrument</ion-label>
          <ion-select
            slot="end"
            v-model="settings.instrument"
            interface="popover"
          >
            <ion-select-option
              v-for="instrument in instruments"
              :key="instrument"
              :value="instrument.toLowerCase()"
            >
              {{ instrument }}
            </ion-select-option>
          </ion-select>
        </ion-item>
        <ion-item lines="none">
          <ion-label>Show Chord Diagrams</ion-label>
          <ion-toggle
            slot="end"
            :checked="settings.showChords"
            @ion-change="settings.showChords = $event.detail.checked"
          />
        </ion-item>
      </ion-list>

      <h5>Layout</h5>

      <ion-segment
        value="settings.columns"
        @ion-change="settings.columns = $event.detail.value"
      >
        <ion-segment-button value="1">
          <ion-label>1</ion-label>
        </ion-segment-button>
        <ion-segment-button value="2">
          <ion-label>2</ion-label>
        </ion-segment-button>
      </ion-segment>
    </div>
  </ion-modal>
</template>
