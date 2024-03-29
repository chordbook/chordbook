<script setup>
import TransposeControl from '@/components/TransposeControl.vue'
import InstrumentControl from '@/components/InstrumentControl.vue'
import useSongsheetSettings from '@/stores/songsheet-settings'
import { ref, onBeforeUnmount } from 'vue'
import { useResponsive } from '@/composables'

defineProps({
  chords: {
    type: Array,
    required: true
  },
  note: {
    type: String,
    required: true
  }
})

const settings = useSongsheetSettings()
const sidebar = useResponsive('sm')
const chordsModal = ref()
const breakpoints = [0.2, 0.6, 1]

function onBreakpointDidChange(event) {
  settings.showChords = event.detail.breakpoint >= breakpoints[1]
}

onBeforeUnmount(() => {
  chordsModal.value?.$el.dismiss()
})
</script>

<template>
  <div
    v-if="sidebar"
    slot="fixed"
    class="left-0 top-0 bottom-0 w-[80px] overflow-y-auto px-3 py-8 bg-white dark:bg-black border-r dark:border-zinc-900"
  >
    <div class="snap-y snap-mandatory">
      <div
        v-for="chord in chords"
        :key="chord"
        class="text-center text-sm snap-start"
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
  </div>
  <ion-modal
    v-else
    ref="chordsModal"
    :is-open="true"
    :initial-breakpoint="settings.showChords ? breakpoints[1] : breakpoints[0]"
    :backdrop-dismiss="false"
    :backdrop-breakpoint="breakpoints[2]"
    :breakpoints="breakpoints"
    handle-behavior="cycle"
    @ion-breakpoint-did-change="onBreakpointDidChange"
  >
    <div class="horizontal-scroller">
      <div
        v-for="chord in chords"
        :key="chord"
        class="text-center text-sm pointer-events-none select-none"
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
    <ion-footer>
      <ion-toolbar>
        <ion-buttons slot="start">
          <transpose-control
            class="ml-4"
            :note="note"
            @update="(v) => settings.transpose = v"
          />
        </ion-buttons>
        <ion-buttons slot="end">
          <instrument-control v-model="settings.instrument" />
        </ion-buttons>
      </ion-toolbar>
    </ion-footer>
  </ion-modal>
</template>

<style scoped>
ion-modal {
  --height:auto;
  --max-width: 100%;
  --box-shadow: 0 28px 48px rgba(0, 0, 0, 0.4);
}

ion-modal::part(handle):focus {
  /* This is just to get rid of focus ring when testing mobile view in development */
  outline: none;
}

.horizontal-scroller {
  @apply flex flex-nowrap gap-2 overflow-x-auto w-full p-6 pb-8;
}

.horizontal-scroller > *:first-child {
  @apply ms-auto;
}

.horizontal-scroller > *:last-child {
  @apply me-auto;
}
</style>
