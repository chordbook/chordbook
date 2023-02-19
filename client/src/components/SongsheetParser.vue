<script setup>
import { ref, computed } from 'vue'
import detectFormat from '@/lib/detect_format'
import { Chord, ChordLyricsPair } from 'chordsheetjs'

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

function normalize (song) {
  return song.mapItems((item) => {
    if (item instanceof ChordLyricsPair) {
      const chords = Chord.parse(item.chords.trim())?.normalize()?.toString() || item.chords
      return item.set({ chords })
    }

    return item
  })
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

const error = ref(null)
const format = computed(() => props.format || detectFormat(props.source))

const song = computed(() => {
  try {
    let song = normalize(format.value?.parse(props.source))
    const chords = chordSet(song)
    if (!song.key) song = song.setKey(guessKey(chords))
    song.chords = chords
    return song
  } catch (err) {
    error.value = err
    return null
  }
})

const transposed = computed(() => {
  if (props.transpose === 0) return song.value

  const transposed = song.value.transpose(props.transpose, { normalizeChordSuffix: true })
  transposed.chords = chordSet(transposed)
  return transposed
})

defineExpose({ song, transposed, error })
</script>

<template>
  <slot v-bind="{ song, transposed, error }" />
</template>
