<script lang="ts" setup>
import ChordData, { Instrument } from "@/ChordData";
import ChordBox from "@/components/ChordBox.vue";
import { ChordDefinition } from "chordsheetjs";
import { computed } from "vue";

const {
  chord,
  definition,
  instrument = Instrument.Guitar,
  position = 0,
} = defineProps<{
  chord: string;
  definition?: ChordDefinition;
  instrument?: Instrument;
  position?: number;
}>();

const data = computed(() => {
  if (definition) {
    return ChordData.fromDefinition(definition);
  } else {
    return ChordData.find(chord, instrument, position);
  }
});
</script>

<template>
  <ChordBox v-if="data" :id="`chord-${chord}`" :data="data" v-bind="$attrs" />
</template>
