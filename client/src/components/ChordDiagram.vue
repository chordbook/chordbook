<template>
  <!-- eslint-disable vue/no-v-html vue/no-v-text-v-html-on-component -->
  <component
    :is="as"
    :id="`chord-${chord}`"
    :width="width"
    :height="height"
    :viewBox="`0 0 ${width} ${height}`"
    v-html="diagram"
  />
</template>

<script>
import { ChordBox } from 'vexchords'
import { Chord } from 'chordsheetjs'
import ChordData from '@/lib/chord-data'

export default {
  props: {
    as: {
      type: String,
      default: 'symbol'
    },
    chord: {
      type: Chord,
      required: true
    },
    instrument: {
      type: String,
      default: 'guitar'
    },
    position: {
      type: Number,
      default: 0
    },
    width: {
      type: [Number, String],
      default: '50'
    },
    height: {
      type: [Number, String],
      default: '65'
    }
  },

  computed: {
    chordData () {
      return ChordData.find(this.chord, this.instrument, this.position)
    },

    diagram () {
      if (!this.chord || !this.chordData) return ''

      const el = document.createElement('div')

      new ChordBox(el, {
        numStrings: this.chordData.strings,
        showTuning: false,
        width: this.width,
        height: this.height,
        defaultColor: 'currentColor'
      }).draw({
        chord: this.chordData.fingerings,
        position: this.chordData.data.baseFret,
        barres: this.chordData.barres
      })

      return el.querySelector('svg').innerHTML
    }
  }
}
</script>
