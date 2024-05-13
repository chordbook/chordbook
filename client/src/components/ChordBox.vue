<script setup>
import { ChordBox } from "vexchords";
import ChordData from "@/ChordData";
import { computed, reactive } from "vue";

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

// Vexchords adds a lot of padding around the diagram, we'll use viewbox to crop it
const padding = 0.1;
const xPadding = computed(() => props.width * padding);
const yPadding = computed(() => props.width * padding);
const viewbox = reactive({
  x: computed(() => xPadding.value + 2), // vexchords seems to draw these slightly shifted right
  y: yPadding,
  width: computed(() => props.width - xPadding.value * 2),
  height: computed(() => props.height - yPadding.value * 2),
});

const diagram = computed(() => {
  if (!props.data) return "";

  const el = document.createElement("div");

  new ChordBox(el, {
    numStrings: props.data.strings,
    showTuning: false,
    width: props.width,
    height: props.height,
    defaultColor: "currentColor",
    numFrets: 4,
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
    :width="viewbox.width"
    :height="viewbox.height"
    :viewBox="`${viewbox.x} ${viewbox.y} ${viewbox.width} ${viewbox.height}`"
    v-html="diagram"
  />
</template>
