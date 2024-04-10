<script setup>
import InstrumentControl from '@/components/InstrumentControl.vue'
import ChordDiagramReference from '@/components/ChordDiagramReference.vue'
import useSongsheetSettings from '@/stores/songsheet-settings'
import { ref, onBeforeUnmount, watch } from 'vue'
import { useResponsive } from '@/composables'

defineProps({
  chords: {
    type: Array,
    required: true
  },
  isOpen: {
    type: Boolean,
    default: true
  }
})

const settings = useSongsheetSettings()
const sidebar = useResponsive('sm')
const chordsModal = ref()
const breakpoints = [0.2, 0.6, 1]

function onBreakpointDidChange (event) {
  settings.showChords = event.detail.breakpoint >= breakpoints[1]
}

function dismissModal () {
  chordsModal.value?.$el.dismiss()
}

// Modal must be dismissed manually since backdrop-dismiss is disabled
onBeforeUnmount(dismissModal)
watch(sidebar, isVisible => { if (isVisible) dismissModal() })
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
    <ion-modal
      ref="chordsModal"
      :is-open="isOpen"
      :initial-breakpoint="settings.showChords ? breakpoints[1] : breakpoints[0]"
      :backdrop-dismiss="false"
      :backdrop-breakpoint="breakpoints[2]"
      :breakpoints="breakpoints"
      handle-behavior="cycle"
      @ion-breakpoint-did-change="onBreakpointDidChange"
    >
      <div class="flex flex-row flex-nowrap overflow-x-auto w-full pt-6 pb-8 snap-x snap-mandatory">
        <div
          v-for="chord in chords"
          :key="`modal-${chord}`"
          class="text-center text-sm pointer-events-none select-none snap-start pl-3 first:pl-6 last:pr-6 first:ms-auto last:me-auto"
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
    </ion-modal>
  </div>
</template>

<style scoped>
.sidebar {
  padding-left: env(safe-area-inset-left, 0);
}

ion-modal {
  --height:auto;
  --max-width: 100%;
  --box-shadow: 0 28px 48px rgba(0, 0, 0, 0.4);
}

.horizontal-scroller > *:first-child {
  @apply ms-auto;
}

.horizontal-scroller > *:last-child {
  @apply me-auto;
}
</style>
