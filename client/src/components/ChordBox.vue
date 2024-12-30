<script lang="ts" setup>
import { ChordBox } from "@chordbook/charts";
import ChordData from "@/ChordData";
import { computed, ref } from "vue";

const { as = 'symbol', data, width = 50, height = 65 } = defineProps<{
  data: ChordData;
  as?: string;
  width?: number;
  height?: number;
}>();

const multiplier = ref(2);

const diagram = computed(() => {
  if (!data) return "";

  const el = document.createElement("div");

  new ChordBox(el, {
    numStrings: data.strings,
    showTuning: false,
    width: width * multiplier.value,
    height: height * multiplier.value,
    defaultColor: "currentColor",
    numFrets: 4,
    fontSize: 10 * multiplier.value,
    strokeWidth: 0.5 * multiplier.value,
  }).draw({
    // Filter out fingerings for now since they're unreadable anyway
    chord: data.fingerings.map(([string, fret]) => [string, fret]),
    position: data.data.baseFret,
    barres: data.barres,
  });

  return el.querySelector("svg")!.innerHTML;
});
</script>

<template>
  <!-- eslint-disable vue/no-v-html vue/no-v-text-v-html-on-component -->
  <component
    :is="as"
    :viewBox="`0 0 ${width * multiplier} ${height * multiplier}`"
    :width="width"
    :height="height"
    v-html="diagram"
  />
</template>
