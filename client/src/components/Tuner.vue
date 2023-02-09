<script>
import { Tuner } from '../lib/tuner'
import TunerMeter from '@/components/TunerMeter.vue'
import TunerNote from '@/components/TunerNote.vue'
import { mic, micOff } from 'ionicons/icons'
import debounce from 'lodash.debounce'

export default {
  components: { TunerMeter, TunerNote },

  data () {
    return {
      a4: 440,
      note: { name: 'A', frequency: 440, octave: 4, cents: null },
      active: false,
      icons: { mic, micOff }
    }
  },

  computed: {
    tuner () {
      return new Tuner(this.a4, n => { this.note = n })
    },

    notes () {
      const minOctave = 1
      const maxOctave = 6
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

  watch: {
    note: debounce(function (note) {
      if (note.cents) this.note.cents = null
    }, 1000)
  },

  methods: {
    async start () {
      this.active = true
      return this.tuner.start().then(() => {
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
      const length = 32 // low frequency only
      const width = el.width / length - 0.5

      const scale = el.height / 2 / Math.max(...this.frequencyData.slice(0, length))

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

<template>
  <div>
    <div class="cursor-default select-none pt-14">
      <div class="w-60 aspect-square mx-auto rounded-full shadow-md border relative">
        <canvas
          ref="frequency-bars"
          class="w-full h-full inset-0 opacity-20 absolute rounded-full"
        />
        <tuner-meter :cents="note.cents" />
        <div class="scrollbar-hide mask-image overflow-y-hidden overflow-x-auto snap-x whitespace-nowrap h-full flex flex-nowrap place-items-center">
          <tuner-note
            v-for="n in notes"
            :key="n.name"
            class="snap-center"
            :name="n.name"
            :octave="n.octave"
            :frequency="n.frequency"
            :active="note.name == n.name && note.octave == n.octave"
          />
        </div>
        <div class="text-gray-500/60 absolute bottom-5 left-0 right-0 text-center whitespace-nowrap">
          <span class="inline-block font-mono text-sm font-bold w-8 ml-2 mr-1 text-right">{{ note.frequency.toFixed(0) }}</span>
          <span class="text-xs">Hz</span>
        </div>
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

<style scoped>
.mask-image {
  mask-image: radial-gradient(
    #fff 30%,
    rgba(255, 255, 255, 0) 50%
  );
}
</style>
