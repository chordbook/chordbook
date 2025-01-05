<script setup lang="ts">
import ChordData, { Instrument } from "@/ChordData";
import { Chord } from "chordsheetjs";
import { computed, ref } from "vue";
import ChordBox from "../components/ChordBox.vue";

import type { ChordPositionData, Keys } from "@/ChordData";

const selectedInstrument = ref(Instrument.Guitar);
const selectedKey = ref("C");
const selectedChord = ref<number>();

const width = ref(75);
const height = ref(100);

const data = computed(() => ChordData.db[selectedInstrument.value]);
const chords = computed(() => data.value.chords[normalizeKey(selectedKey.value)]);
const chordData = computed(() => chords.value?.[selectedChord.value!]);

function normalizeChordName(name: string) {
  return Chord.parse(name)?.normalize()?.toString({ useUnicodeModifier: true });
}

function normalizeKey(key: string) {
  return key.replace(/#/, "sharp") as Keys;
}

function positionData(position: ChordPositionData) {
  return new ChordData(position);
}
</script>

<template>
  <IonModal>
    <AppView>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Chord Reference</IonTitle>
          <IonSelect
            slot="start"
            v-model="selectedInstrument"
            aria-label="Instrument"
            interface="popover"
          >
            <IonSelectOption
              v-for="instrument in Instrument"
              :key="instrument"
              :value="instrument.toLowerCase()"
            >
              {{ instrument }}
            </IonSelectOption>
          </IonSelect>
          <IonButtons slot="end">
            <IonBackButton role="cancel" icon="" text="Done" default-href="/" />
          </IonButtons>
        </IonToolbar>
        <IonToolbar>
          <IonSegment v-model="selectedKey" class="mx-auto max-w-4xl" scrollable>
            <IonSegmentButton v-for="key in data?.keys" :key="key" :value="key">
              <IonLabel>{{ Chord.parse(key)!.toString({ useUnicodeModifier: true }) }}</IonLabel>
            </IonSegmentButton>
          </IonSegment>
        </IonToolbar>
      </IonHeader>
      <IonContent class="ion-padding">
        Key: {{ selectedKey }} Chord: {{ selectedChord }}
        <IonList lines="none" class="mt-6 chord-grid">
          <template v-for="(chord, index) in chords" :key="chord.key + chord.suffix">
            <IonItem
              v-if="normalizeChordName(chord.key + chord.suffix)"
              button
              :detail="false"
              @click="() => (selectedChord = index)"
            >
              <div class="flex flex-col items-center pt-3">
                <h2 class="text-sm">
                  {{ normalizeChordName(chord.key + chord.suffix) }}
                </h2>
                <ChordBox
                  as="svg"
                  :data="positionData(chord.positions[0])"
                  :width="width"
                  :height="height"
                />
              </div>
            </IonItem>
          </template>
        </IonList>
      </IonContent>
      <IonModal
        :is-open="selectedChord !== undefined"
        :initial-breakpoint="0.5"
        :breakpoints="[0, 0.5, 1]"
        @did-dismiss="selectedChord = undefined"
      >
        <IonPage>
          <IonHeader>
            <IonToolbar>
              <IonTitle>
                {{ normalizeChordName(chordData!.key + chordData!.suffix) }}
              </IonTitle>
            </IonToolbar>
          </IonHeader>
          <IonContent class="ion-padding">
            <div class="mt-6 chord-grid text-center">
              <div v-for="(position, index) in chordData!.positions" :key="index" class="flex-grow">
                <h3>{{ index + 1 }}</h3>
                <ChordBox
                  class="inline"
                  as="svg"
                  :data="positionData(position)"
                  :width="width"
                  :height="height"
                />
              </div>
            </div>
          </IonContent>
        </IonPage>
      </IonModal>
    </AppView>
  </IonModal>
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
