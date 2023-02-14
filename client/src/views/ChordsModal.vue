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

const width = ref(112)
const height = ref(150)

const data = computed(() => db[selectedInstrument.value])
const chords = computed(() => data.value?.chords[normalizeKey(selectedKey.value)])
const chordData = computed(() => chords.value?.[selectedChord.value])

function normalizeChordName (name) {
  return Chord.parse(name).normalize().toString({ useUnicodeModifier: true })
}

function normalizeKey (key) {
  return key.replace(/#/, 'sharp')
}

function positionData(position) {
  return new ChordData(position)
}
</script>

<template>
  <ion-modal>
    <app-view>
      <ion-header>
        <ion-toolbar>
          <ion-title>Chord Reference</ion-title>
          <ion-select
            slot="start"
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
          <ion-buttons slot="end">
            <ion-back-button
              role="cancel"
              icon=""
              text="Done"
              default-href="/"
            />
          </ion-buttons>
        </ion-toolbar>
        <ion-toolbar>
          <ion-segment
            v-model="selectedKey"
            class="mx-auto max-w-4xl"
            scrollable
          >
            <ion-segment-button
              v-for="key in data?.keys"
              :key="key"
              :value="key"
            >
              <ion-label>{{ Chord.parse(key).toString({ useUnicodeModifier: true }) }}</ion-label>
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
            v-for="(chord, index) in chords"
            :key="chord.key + chord.suffix"
            button
            :detail="false"
            @click="() => selectedChord = index"
          >
            <div class="flex flex-col items-center pt-3">
              <h2 class="text-sm">
                {{ normalizeChordName(chord.key + chord.suffix) }}
              </h2>
              <chord-box
                as="svg"
                :data="positionData(chord.positions[0])"
                :width="width"
                :height="height"
              />
            </div>
          </ion-item>
        </ion-list>
      </ion-content>
      <ion-modal
        :is-open="selectedChord !== null"
        :initial-breakpoint="0.5"
        :breakpoints="[0, 0.5, 1]"
        @did-dismiss="selectedChord = null"
      >
        <ion-page>
          <ion-header>
            <ion-toolbar>
              <ion-title>
                {{ normalizeChordName(chordData.key + chordData.suffix) }}
              </ion-title>
            </ion-toolbar>
          </ion-header>
          <ion-content class="ion-padding">
            <div class="mt-6 chord-grid text-center">
              <div
                v-for="(position, index) in chordData.positions"
                :key="index"
                class="flex-grow"
              >
                <h3>{{ index + 1 }}</h3>
                <chord-box
                  class="inline"
                  as="svg"
                  :data="positionData(position)"
                  :width="width"
                  :height="height"
                />
              </div>
            </div>
          </ion-content>
        </ion-page>
      </ion-modal>
    </app-view>
  </ion-modal>
</template>

<style>
.chord-grid {
  @apply flex flex-wrap;
}

.chord-grid > ion-item {
  --padding-start: 0;
  --padding-end: 0;
  --inner-padding-end: 0;
}
</style>
