<script setup>
import { ChordDefinition } from "chordsheetjs";
import ChordData from "@/ChordData";
import ChordBox from "@/components/ChordBox.vue";
import { computed } from "vue";

const props = defineProps({
  chord: {
    type: String,
    required: true,
  },
  definition: {
    type: ChordDefinition,
    default: null,
  },
  instrument: {
    type: String,
    default: "guitar",
  },
  position: {
    type: Number,
    default: 0,
  },
});

const data = computed(() => {
  if(props.definition) {
    return ChordData.fromDefinition(props.definition);
  } else {
    return ChordData.find(props.chord, props.instrument, props.position)
  }
});
</script>

<template>
  <chord-box v-if="data" :id="`chord-${chord}`" :data="data" v-bind="$attrs" />
</template>
