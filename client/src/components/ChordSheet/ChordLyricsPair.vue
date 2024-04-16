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
    <div
      v-if="item.annotation"
      class="annotation"
    >
      {{ item.annotation }}
    </div>
    <chord
      v-else
      :name="item.chords"
    />
    <div
      v-if="item.lyrics?.trim()"
      class="lyrics"
    >
      {{ item.lyrics }}
    </div>
  </div>
</template>
