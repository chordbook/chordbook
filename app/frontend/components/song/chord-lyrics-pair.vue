<template>
  <div class="column">
    <chord :name="item.transposed" />
    <div class="lyrics">
      {{ item.lyrics }}
    </div>
  </div>
</template>

<script>
import { ChordLyricsPair } from 'chordsheetjs'

export default {
  for: function (item) {
    return item instanceof ChordLyricsPair
  },

  props: {
    item: ChordLyricsPair
  }
}
</script>
