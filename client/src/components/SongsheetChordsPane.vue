<script setup>
import InstrumentControl from '@/components/InstrumentControl.vue'
import ChordDiagramReference from '@/components/ChordDiagramReference.vue'
import useSongsheetSettings from '@/stores/songsheet-settings'
import Pane from '@/components/Pane.vue'
import { ref, defineExpose, computed } from 'vue'
import { useResponsive } from '@/composables'

defineProps({
  chords: {
    type: Array,
    required: true
  }
})

defineExpose({
  height: computed(() => chordsModal?.value?.height),
  transition: computed(() => chordsModal?.value?.transition)
})

const settings = useSongsheetSettings()
const sidebar = useResponsive('sm')
const chordsModal = ref()

function onBreakpointDidChange (breakpoint) {
  settings.showChords = breakpoint !== 'bottom'
}
</script>

<template>
  <div
    v-if="sidebar"
    class="left-0 top-0 bottom-0 sidebar bg-white dark:bg-black border-r dark:border-slate-800"
  >
    <div class="w-[80px] snap-y snap-mandatory flex flex-col overflow-y-auto px-3 h-full">
      <div
        v-for="chord in chords"
        :key="`sidebar-${chord}`"
        class="text-center text-sm snap-start pt-4 first:pt-6 last:pb-6"
      >
        <div>{{ chord.toString({ useUnicodeModifier: true}) }}</div>
        <chord-diagram-reference :chord="chord" />
      </div>
    </div>
  </div>
  <div v-else>
    <pane
      ref="chordsModal"
      :is-open="true"
      :settings="{
        initialBreak: settings.showChords ? 'middle' : 'bottom',
        breaks: {
          top: { enabled: true, height: 172 },
          middle: { enabled: true, height: 120 },
          bottom: { enabled: true, height: 33 }
        }
      }"
      @breakpoint-did-change="onBreakpointDidChange"
    >
      <div class="flex flex-row flex-nowrap overflow-x-auto w-full py-4 snap-x snap-mandatory">
        <div
          v-for="chord in chords"
          :key="`modal-${chord}`"
          class="flex flex-col text-center text-sm pointer-events-none select-none snap-start pl-3 first:pl-6 last:pr-6 first:ms-auto last:me-auto"
        >
          <div class="chord">
            {{ chord.toString({ useUnicodeModifier: true }) }}
          </div>
          <chord-diagram-reference :chord="chord" />
        </div>
      </div>
      <ion-footer>
        <ion-toolbar>
          <ion-buttons slot="end">
            <instrument-control v-model="settings.instrument" />
          </ion-buttons>
        </ion-toolbar>
      </ion-footer>
    </pane>
  </div>
</template>

<style scoped>
.sidebar {
  padding-left: env(safe-area-inset-left, 0);
}

.horizontal-scroller > *:first-child {
  @apply ms-auto;
}

.horizontal-scroller > *:last-child {
  @apply me-auto;
}
</style>
