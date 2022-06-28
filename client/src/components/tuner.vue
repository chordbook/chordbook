<template>
  <div class="p-6 relative cursor-default select-none">
    <canvas
      ref="frequency-bars"
      class="opacity-20 absolute right-0 bottom-0 left-0 h-1/2 w-full z-0"
    />
    <tuner-meter :cents="note.cents" />
    <div
      ref="notes"
      class="text-center"
    >
      <div class="notes-list overflow-y-hidden overflow-x-auto whitespace-nowrap my-2">
        <tuner-note
          v-for="n in notes"
          :key="n.name"
          :name="n.name"
          :octave="n.octave"
          :frequency="n.frequency"
          :active="note.name == n.name && note.octave == n.octave"
        />
      </div>
      <div class="text-gray-500">
        {{ note.frequency.toFixed(1) }} <span>Hz</span>
      </div>
    </div>

    <div class="mt-4 text-center">
      <ion-button
        v-if="!active"
        color="success"
        @click="start"
      >
        <ion-icon
          slot="icon-only"
          :icon="icons.mic"
        />
      </ion-button>
      <ion-button
        v-if="active"
        color="danger"
        type="reset"
        @click="stop"
      >
        <ion-icon
          slot="icon-only"
          :icon="icons.micOff"
          class="animate-pulse"
        />
      </ion-button>
    </div>
  </div>
</template>

<script>
import { Tuner } from '../lib/tuner'
import TunerMeter from '@/components/tuner-meter.vue'
import TunerNote from '@/components/tuner-note.vue'
import { mic, micOff } from 'ionicons/icons'

export default {
  components: { TunerMeter, TunerNote },

  data () {
    return {
      a4: 440,
      note: { name: 'A', frequency: 440, octave: 4, cents: 0 },
      active: false,
      icons: { mic, micOff }
    }
  },

  computed: {
    tuner () {
      return new Tuner(this.a4)
    },

    notes () {
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
    toggle () {
      return this.active ? this.stop() : this.start()
    },

    async start () {
      this.active = true
      return this.tuner.start(n => { this.note = n }).then(() => {
        this.frequencyData = new Uint8Array(this.tuner.analyser.frequencyBinCount)
        this.updateFrequencyBars()
      })
    },

    async stop () {
      this.active = false
      await this.tuner.stop()
      Object.assign(this.$data, this.$options.data())
    },

    updateFrequencyBars () {
      if (!this.active) return

      this.tuner.analyser.getByteFrequencyData(this.frequencyData)
      const el = this.$refs['frequency-bars']
      const length = 64 // low frequency only
      const width = el.width / length - 0.5

      window.frequencyData = this.frequencyData
      const scale = el.height / Math.max(...this.frequencyData.slice(0, length))

      const canvasContext = el.getContext('2d')
      canvasContext.clearRect(0, 0, el.width, el.height)

      for (let i = 0; i < length; i += 1) {
        canvasContext.fillStyle = 'rgb(120,120,120)'
        canvasContext.fillRect(
          i * (width + 0.5),
          el.height - Math.floor(this.frequencyData[i] * scale),
          width,
          Math.floor(this.frequencyData[i] * scale)
        )
      }

      requestAnimationFrame(this.updateFrequencyBars.bind(this))
    }
  }
}
</script>

<style>
.notes-list {
  scrollbar-width: none;
  overflow: -moz-scrollbars-none;
  -ms-overflow-style: none;
  -webkit-mask-image: -webkit-linear-gradient(
    left,
    rgba(255, 255, 255, 0),
    #fff,
    rgba(255, 255, 255, 0)
  );
}

.notes-list::-webkit-scrollbar {
  @apply hidden;
}
</style>
