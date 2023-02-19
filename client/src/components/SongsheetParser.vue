<script setup>
import { computed } from 'vue'
import detectFormat from '@/lib/detect_format'
import { Chord } from 'chordsheetjs'

const props = defineProps({
  source: {
    type: String,
    default: null
  },
  format: {
    type: String,
    default: null
  },
  transpose: {
    type: Number,
    default: 0
  }
})

function guessKey (chords) {
  // FIXME: use intelligent key detection
  return chords[0]?.toString()
}

function chordSet (song) {
  const chords = new Set()

  song.lines.forEach(line => {
    line.items.forEach(pair => {
      if (pair.chords) chords.add(pair.chords)
    })
  })

  return Array.from(chords).map(name => Chord.parse(name)).filter(Boolean)
}

const format = computed(() => props.format || detectFormat(props.source))

const song = computed(() => {
  let song = format.value?.parse(props.source)
  const chords = chordSet(song)
  if (!song.key) song = song.setKey(guessKey(chords))
  song.chords = chords
  return song
})

const transposed = computed(() => {
  if (props.transpose === 0) return song.value

  const transposed = song.value.transpose(props.transpose, { normalizeChordSuffix: true })
  transposed.chords = chordSet(transposed)
  return transposed
})

defineExpose({ song, transposed })
</script>

<template>
  <slot v-bind="{ song, transposed }" />
</template>
