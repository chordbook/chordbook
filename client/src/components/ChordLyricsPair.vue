<template>
  <div class="column">
    <song-sheet-chord :name="item.chords" />
    <div v-if="item.lyrics?.trim()" class="lyrics">
      {{ item.lyrics }}
    </div>
  </div>
</template>

<script>
import { ChordLyricsPair } from 'chordsheetjs'
import SongSheetChord from '@/components/SongSheetChord.vue'

export default {
  components: { SongSheetChord },

  for: function (item) {
    return item instanceof ChordLyricsPair
  },

  props: {
    item: ChordLyricsPair
  }
}
</script>
