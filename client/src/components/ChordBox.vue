<script setup>
import { ChordBox } from "vexchords";
import ChordData from "@/ChordData";
import { computed, ref } from "vue";

const props = defineProps({
  as: {
    type: String,
    default: "symbol",
  },
  data: {
    type: ChordData,
    required: true,
  },
  width: {
    type: [Number, String],
    default: "50",
  },
  height: {
    type: [Number, String],
    default: "65",
  },
});

const multiplier = ref(2);
const width = computed(() => props.width * multiplier.value)
const height = computed(() => props.height * multiplier.value)

const diagram = computed(() => {
  if (!props.data) return "";

  const el = document.createElement("div");

  new ChordBox(el, {
    numStrings: props.data.strings,
    showTuning: false,
    width: width.value,
    height: height.value,
    defaultColor: "currentColor",
    numFrets: 4,
    fontSize: 10 * multiplier.value,
    strokeWidth: 0.5 * multiplier.value,
  }).draw({
    // Filter out fingerings for now since they're unreadable anyway
    chord: props.data.fingerings.map((f) => f.slice(0, 2)),
    position: props.data.data.baseFret,
    barres: props.data.barres,
  });

  return el.querySelector("svg").innerHTML;
});
</script>

<template>
  <!-- eslint-disable vue/no-v-html vue/no-v-text-v-html-on-component -->
  <component
    :is="as"
    :viewBox="`0 0 ${width} ${height}`"
    :width="width / multiplier"
    :height="height / multiplier"
    v-html="diagram"
  />
</template>
