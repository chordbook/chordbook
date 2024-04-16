<script>
import { ChordLyricsPair } from 'chordsheetjs'
import Chord from './Chord.vue'

export default {
  components: { Chord },

  for: function (item) {
    return item instanceof ChordLyricsPair
  },

  props: {
    item: ChordLyricsPair
  }
}
</script>

<template>
  <div class="column">
    <chord :name="item.chords" />
    <div
      v-if="item.lyrics?.trim()"
      class="lyrics"
    >
      {{ item.lyrics }}
    </div>
  </div>
</template>
