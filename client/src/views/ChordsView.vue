<script setup>
import guitar from '@tombatossals/chords-db/lib/guitar.json'
import ukulele from '@tombatossals/chords-db/lib/ukulele.json'
import ChordBox from '../components/ChordBox.vue'
import ChordData from '@/lib/chord-data'
import { ref, computed } from 'vue'
import { Chord } from 'chordsheetjs'

const db = {
  guitar,
  ukulele
}

const instruments = ['Guitar', 'Ukulele']
const selectedInstrument = ref(instruments[0].toLowerCase())
const selectedKey = ref('C')
const selectedChord = ref(null)
const data = computed(() => db[selectedInstrument.value])

function normalizeChordName (name) {
  return Chord.parse(name).normalize().toString({ useUnicodeModifier: true })
}

function normalizeKey (key) {
  return key.replace(/#/, 'sharp')
}
</script>

<template>
  <app-view>
    <ion-header>
      <ion-toolbar>
        <ion-title>Chord Reference</ion-title>
        <ion-select
          slot="end"
          v-model="selectedInstrument"
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
      </ion-toolbar>
      <ion-toolbar>
        <ion-segment
          v-model="selectedKey"
          class="mx-auto max-w-4xl"
          scrollable
        >
          <ion-segment-button
            v-for="key in data.keys"
            :key="key"
            :value="key"
          >
            <ion-label>{{ key }}</ion-label>
          </ion-segment-button>
        </ion-segment>
      </ion-toolbar>
    </ion-header>
    <ion-content class="ion-padding">
      <ion-list
        lines="none"
        class="mt-6 chord-grid"
      >
        <ion-item
          v-for="chord in data.chords[normalizeKey(selectedKey)]"
          :key="chord.key + chord.suffix"
          button
          :detail="false"
          @click="() => selectedChord = chord"
        >
          <div class="flex flex-col items-center">
            <h2 class="text-sm">
              {{ normalizeChordName(chord.key + chord.suffix) }}
            </h2>
            <chord-box
              as="svg"
              :data="new ChordData(chord.positions[0])"
              width="75"
              height="100"
            />
          </div>
        </ion-item>
      </ion-list>
    </ion-content>
    <ion-modal
      :is-open="!!selectedChord"
      :initial-breakpoint="0.33"
      :breakpoints="[0, 0.33, 0.66, 1]"
      @did-dismiss="selectedChord = null"
    >
      <ion-page>
        <ion-header>
          <ion-toolbar>
            <ion-title>
              {{ normalizeChordName(selectedChord.key + selectedChord.suffix) }}
            </ion-title>
          </ion-toolbar>
        </ion-header>
        <ion-content class="ion-padding">
          <!-- {{ parseChord(selectedChord).normalize().toString({ useUnicodeModifier: true }) }} -->
          <div class="mt-6 chord-grid text-center">
            <div
              v-for="(position, index) in selectedChord.positions"
              :key="index"
            >
              <h3>{{ index + 1 }}</h3>
              <chord-box
                class="inline"
                as="svg"
                :data="new ChordData(position)"
                width="75"
                height="100"
              />
            </div>
          </div>
        </ion-content>
      </ion-page>
    </ion-modal>
  </app-view>
</template>

<style>
.chord-grid {
  @apply grid gap-2;
  grid-template-columns: repeat(auto-fit, minmax(75px, 1fr))
}

.chord-grid > ion-item {
  --padding-start: 0;
}
</style>
