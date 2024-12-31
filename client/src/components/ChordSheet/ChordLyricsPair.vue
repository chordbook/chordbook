<script lang="ts">
import { ChordLyricsPair } from "chordsheetjs";

export default {
  for: function (item: unknown): item is ChordLyricsPair {
    return item instanceof ChordLyricsPair;
  }
};
</script>

<script lang="ts" setup>
import Chord from "./Chord.vue";

defineProps<{
  item: ChordLyricsPair
}>();
</script>

<template>
  <div class="column">
    <div v-if="item.annotation" class="annotation">
      {{ item.annotation }}
    </div>
    <chord v-else :name="item.chords" />
    <div v-if="item.lyrics?.trim()" class="lyrics">
      {{ item.lyrics }}
    </div>
  </div>
</template>
