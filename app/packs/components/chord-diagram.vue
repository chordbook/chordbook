<template>
  <!-- eslint-disable vue/no-v-html -->
  <component
    :is="as"
    :id="`chord-${name}`"
    :width="width"
    :height="height"
    :viewBox="`0 0 ${width} ${height}`"
    v-html="diagram"
  />
</template>

<script>
import { ChordBox } from 'vexchords'
import Chord from '../lib/chord'

export default {
  props: {
    as: {
      type: String,
      default: 'symbol'
    },
    name: {
      type: String,
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
    chord () {
      return new Chord(this.name, this.instrument, this.position)
    },

    diagram () {
      if (!this.chord) return ''

      const el = document.createElement('div')

      new ChordBox(el, {
        numStrings: this.chord.strings,
        showTuning: false,
        width: this.width,
        height: this.height,
        defaultColor: 'currentColor'
      }).draw({
        chord: this.chord.fingerings,
        position: this.chord.data.baseFret,
        barres: this.chord.barres
      })

      return el.querySelector('svg').innerHTML
    }
  }
}
</script>
