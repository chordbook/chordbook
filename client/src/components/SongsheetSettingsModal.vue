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
    style="--height:max-content"
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
        <ion-item>
          <ion-label>Show Chord Diagrams</ion-label>
          <ion-toggle
            slot="end"
            :checked="settings.showChords"
            @ion-change="settings.showChords = $event.detail.checked"
          />
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
          <ion-label>
            Show Media Player
          </ion-label>
          <ion-toggle
            slot="end"
            :checked="settings.showPlayer"
            @ion-change="settings.showPlayer = $event.detail.checked"
          />
        </ion-item>
      </ion-list>
    </div>
  </ion-modal>
</template>
