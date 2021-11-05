<template>
  <symbol :id="`chord-${name}`" :width="width" :height="height" :viewBox="`0 0 ${width} ${height}`" v-html="diagram"></symbol>
</template>

<script>
import { ChordBox } from 'vexchords'
import Chord from '../lib/chord'

export default {
  data: () => {
    return {
      position: 0,
      width: 50,
      height: 65
    }
  },

  props: {
    name: String,
    instrument: {
      type: String,
      default: 'guitar'
    }
  },

  computed: {
    chord() {
      try {
        return new Chord(this.name, this.instrument, this.position)
      } catch(err) {
        console.error(err)
      }
    },

    diagram() {
      if(!this.chord) return "";

      const el = document.createElement('div')

      const chordbox = new ChordBox(el, {
        numStrings: this.chord.strings,
        numFrets: 4,
        showTuning: false,
        width: this.width,
        height: this.height,
        defaultColor: 'currentColor',
      }).draw({
        chord: this.chord.fingerings,
        position: this.chord.data.baseFret,
        barres: this.chord.barres
      })

      return el.querySelector('svg').innerHTML
    },
  }
}
</script>
