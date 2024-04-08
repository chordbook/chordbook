<script setup>
import { createTuner } from '@chordbook/tuner'
import TunerMeter from '@/components/TunerMeter.vue'
import { mic, micOff } from 'ionicons/icons'
import debounce from 'lodash.debounce'
import { ref, watch } from 'vue'

const frequencyBars = ref(null) // template ref
const tuner = createTuner({ onNote: (n) => { note.value = n } })
const note = ref(tuner.getNote(tuner.config.a4))
const active = ref(false)

let frequencyData = null

// Clear cents after 1 second
watch(note, debounce((note) => { note.cents = null }, 1000))

async function start () {
  active.value = true
  await tuner.start()
  frequencyData = new Uint8Array(tuner.analyser.frequencyBinCount)
  updateFrequencyBars()
}

async function stop () {
  active.value = false
  await tuner.stop()
  note.value = tuner.getNote(tuner.config.a4)
}

function updateFrequencyBars () {
  if (!active.value) return

  tuner.analyser.getByteFrequencyData(frequencyData)
  const el = frequencyBars.value
  const length = Math.sqrt(frequencyData.length) * 2 // low frequency only
  const width = el.width / length - 0.5

  const scale = el.height / 2 / Math.max(...frequencyData.slice(0, length))

  const canvasContext = el.getContext('2d')
  canvasContext.clearRect(0, 0, el.width, el.height)

  for (let i = 0; i < length; i += 1) {
    canvasContext.fillStyle = 'rgb(120,120,120)'
    canvasContext.fillRect(
      i * (width + 0.5),
      el.height - Math.floor(frequencyData[i] * scale),
      width,
      Math.floor(frequencyData[i] * scale)
    )
  }

  requestAnimationFrame(updateFrequencyBars)
}
</script>

<template>
  <div>
    <div class="cursor-default select-none">
      <div class="w-60 aspect-square mx-auto rounded-full shadow-lg border dark:bg-black/30 dark:border-black/60 relative flex">
        <canvas
          ref="frequencyBars"
          class="w-full h-full inset-0 opacity-20 absolute rounded-full"
        />
        <tuner-meter :cents="note.cents" />
        <div class="mx-auto my-auto relative">
          <div class="text-8xl font-bold relative">
            {{ note.name[0] }}
            <span class="absolute font-normal text-3xl top-2 -right-5">{{ note.name[1] || '' }}</span>
            <span class="absolute font-normal text-lg opacity-70 bottom-1 -right-5">{{ note.octave }}</span>
          </div>
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
          :icon="mic"
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
          :icon="micOff"
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
