<script setup>
import useSongsheetSettings from '@/stores/songsheet-settings'
import { ref, watch } from 'vue'

defineProps({
  chords: {
    type: Array,
    required: true
  }
})

const settings = useSongsheetSettings()
const expanded = ref(settings.showChords)

const instruments = ['Guitar', 'Ukulele']
const breakpoints = [0.2, 1]

watch(expanded, value => { settings.showChords = value })
</script>

<template>
  <ion-modal
    ref="chordsModal"
    :is-open="true"
    :animated="false"
    :enter-animation="null"
    :leave-animation="null"
    :initial-breakpoint="expanded ? breakpoints[1] : breakpoints[0]"
    :backdrop-dismiss="false"
    :backdrop-breakpoint="breakpoints[1]"
    :breakpoints="breakpoints"
    handle-behavior="cycle"
    @ion-breakpoint-did-change="e => expanded = e.detail.breakpoint === breakpoints[1]"
  >
    <div class="flex gap-2 overflow-x-auto place-content-center pt-6 px-4 pb-2 place-items-center">
      <ion-select
        v-model="settings.instrument"
        aria-label="Instrument"
        interface="popover"
        class=""
      >
        <ion-select-option
          v-for="instrument in instruments"
          :key="instrument"
          :value="instrument.toLowerCase()"
        >
          {{ instrument }}
        </ion-select-option>
      </ion-select>
      <div
        v-for="chord in chords"
        :key="chord"
        class="text-center text-sm"
      >
        <div class="chord">
          {{ chord.toString({ useUnicodeModifier: true}) }}
        </div>
        <svg
          class="chord-diagram inline-block"
          xmlns="http://www.w3.org/2000/svg"
          role="image"
          :title="chord.toString({ useUnicodeModifier: true })"
        >
          <use
            :xlink:href="`#chord-${chord}`"
            viewBox="0 0 50 65"
          />
        </svg>
      </div>
    </div>
  </ion-modal>
</template>

<style scoped>
ion-modal {
  --height:auto;
  --width: auto;
  --max-width: 100%;
  --box-shadow: 0 28px 48px rgba(0, 0, 0, 0.4);
}

@media (min-width: 640px) {
  ion-modal {
      --max-width: 90%;
  }
}

ion-toolbar {
  --background: transparent;
  @apply transition-opacity;
}
</style>
