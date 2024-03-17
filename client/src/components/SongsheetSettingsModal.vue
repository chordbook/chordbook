<script setup>
import { defineProps } from 'vue'
import TransposeControl from '@/components/TransposeControl.vue'
import useSongsheetSettings from '@/stores/songsheet-settings'
import { tabletPortraitOutline, tabletLandscapeOutline } from 'ionicons/icons'

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
    style="--height:auto"
  >
    <div class="ion-padding-vertical">
      <ion-list-header>Settings</ion-list-header>

      <ion-list class="mb-2">
        <ion-item>
          <ion-label>Transpose</ion-label>
          <transpose-control
            slot="end"
            :note="note"
            @update="(v) => settings.transpose = v"
          />
        </ion-item>

        <ion-item>
          <ion-select
            v-model="settings.instrument"
            label="Instrument"
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
        <ion-item>
          <ion-toggle
            :checked="settings.showChords"
            @ion-change="settings.showChords = $event.detail.checked"
          >
            Show Chord Diagrams
          </ion-toggle>
        </ion-item>
        <ion-item>
          <ion-label>Layout</ion-label>
          <div slot="end">
            <ion-segment
              :value="settings.columns"
              @ion-change="settings.columns = $event.detail.value"
            >
              <ion-segment-button
                :value="1"
                layout="icon-start"
                class="py-1"
              >
                <ion-icon :icon="tabletPortraitOutline" />
              </ion-segment-button>
              <ion-segment-button
                :value="2"
                layout="icon-start"
                class="py-1"
              >
                <ion-icon :icon="tabletLandscapeOutline" />
              </ion-segment-button>
            </ion-segment>
          </div>
        </ion-item>
        <ion-item lines="none">
          <ion-toggle
            :checked="settings.showPlayer"
            @ion-change="settings.showPlayer = $event.detail.checked"
          >
            Show Media Player
          </ion-toggle>
        </ion-item>
      </ion-list>
    </div>
  </ion-modal>
</template>
