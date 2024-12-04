<script setup>
import { Line, SoftLineBreak } from "chordsheetjs";
import ChordSheet from "./index.vue";
import { computed } from "vue";

const props = defineProps({
  item: Line,
});

const phrases = computed(() => {
  // Split items into phrases separated by SoftLineBreak instances
  return props.item.items.reduce((acc, i) => {
    acc[acc.length - 1].push(i);
    if (i instanceof SoftLineBreak) {
      acc.push([]);
    }
    return acc;
  }, [[]]);
});
</script>

<template>
  <div v-if="item.hasRenderableItems()" class="row">
    <div v-for="(column, n) in phrases" :key="n" class="chordsheet-line">
      <template v-for="(i, k) in column" :key="k">
        <ChordSheet :item="i" />
      </template>
    </div>
  </div>
</template>

<style>
.chordsheet-line {
  @apply flex flex-wrap relative break-inside-avoid basis-full md:basis-auto;
}

.using-columns .chordsheet-line {
  @apply basis-full;
}
</style>
