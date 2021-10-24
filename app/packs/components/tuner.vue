<template>
  <div>
    <tuner-meter :cents="note.cents"></tuner-meter>
    <div ref="notes" class="notes">
      <div class="notes-list">
        <tuner-note v-for="note in notes"
          :key="note.name"
          :name="note.name"
          :octave="note.octave"
          :frequency="note.frequency"
          :active="this.note.name == note.name && this.note.octave == note.octave"></tuner-note>
      </div>
      <div class="frequency">{{ note.frequency.toFixed(1) }} <span>Hz</span></div>
    </div>
    <canvas class="frequency-bars" ref="frequency-bars"></canvas>
    <div class="a4">A<sub>4</sub> = <span>440</span> Hz</div>

    <button class="btn btn-primary" @click="start">Start</button>
    <button class="btn btn-default" @click="stop">Stop</button>
  </div>
</template>

<script>
import { Tuner } from '../lib/tuner'
import Meter from './tuner/meter.vue'
import Note from './tuner/note.vue'

export default {
  components: {
    "tuner-meter": Meter,
    "tuner-note": Note,
  },

  data() {
    return {
      a4: 440,
      note: { name: 'A', frequency: 440, octave: 4, cents: 0 },
      active: false
    }
  },

  mounted() {
    const canvas = this.$refs["frequency-bars"]
    canvas.width = document.body.clientWidth
    canvas.height = document.body.clientHeight / 2
  },

  computed: {
    tuner() {
      return new Tuner(this.a4)
    },

    notes() {
      const minOctave = 2
      const maxOctave = 5
      const notes = []

      for (let octave = minOctave; octave <= maxOctave; octave += 1) {
        for (let n = 0; n < 12; n += 1) {
          const value = 12 * (octave + 1) + n
          notes.push({
            name: this.tuner.noteStrings[n],
            octave: octave.toString(),
            frequency: this.tuner.getStandardFrequency(value)
          })
        }
      }

      return notes
    }
  },

  methods: {
    async start() {
      this.active = true
      return this.tuner.start(note => this.$data.note = note).then(() => {
        this.frequencyData = new Uint8Array(this.tuner.analyser.frequencyBinCount)
        this.updateFrequencyBars()
      })
    },

    stop() {
      this.active = false
      return this.tuner.stop()
    },

    updateFrequencyBars () {
      if (!this.active) return

      this.tuner.analyser.getByteFrequencyData(this.frequencyData)
      const el = this.$refs["frequency-bars"]
      const length = 64 // low frequency only
      const width = el.width / length - 0.5

      const canvasContext = el.getContext('2d')
      canvasContext.clearRect(0, 0, el.width, el.height)

      for (let i = 0; i < length; i += 1) {
        canvasContext.fillStyle = '#ecf0f1'
        canvasContext.fillRect(
          i * (width + 0.5),
          el.height - this.frequencyData[i],
          width,
          this.frequencyData[i]
        )
      }

      requestAnimationFrame(this.updateFrequencyBars.bind(this))
    },
  }
}
</script>

<style>
html {
  height: 100%;
}

body {
  position: fixed;
  font-family: sans-serif;
  color: #2c3e50;
  margin: 0;
  width: 100%;
  height: 100%;
  cursor: default;
  -webkit-user-select: none;
  -moz-user-select: none;
}

.notes {
  margin: auto;
  width: 400px;
  position: fixed;
  top: 50%;
  left: 0;
  right: 0;
  text-align: center;
}

.note {
  font-size: 90px;
  font-weight: bold;
  position: relative;
  display: inline-block;
  padding-right: 30px;
  padding-left: 10px;
}

.note.active {
  color: #e74c3c;
}

.notes-list {
  overflow: auto;
  overflow: -moz-scrollbars-none;
  white-space: nowrap;
  -ms-overflow-style: none;
  -webkit-mask-image: -webkit-linear-gradient(
    left,
    rgba(255, 255, 255, 0),
    #fff,
    rgba(255, 255, 255, 0)
  );
}

.notes-list::-webkit-scrollbar {
  display: none;
}

.note {
  -webkit-tap-highlight-color: transparent;
}

.note span {
  position: absolute;
  right: 0.25em;
  font-size: 40%;
  font-weight: normal;
}

.note-sharp {
  top: 0.3em;
}

.note-octave {
  bottom: 0.3em;
}

.frequency {
  font-size: 32px;
}

.frequency span {
  font-size: 50%;
  margin-left: 0.25em;
}

.frequency-bars {
  opacity: 0.5;
  position: fixed;
  bottom: 0;
}

@media (max-width: 768px) {
  .meter {
    width: 100%;
  }

  .notes {
    width: 100%;
  }
}

/*
.a4 {
  position: absolute;
  top: 16px;
  left: 16px;
}
*/

.a4 span {
  color: #e74c3c;
}
</style>
