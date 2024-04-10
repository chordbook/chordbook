import { ref, watch, computed, watchEffect, toValue } from 'vue'
import detectFormat from '@/lib/detect_format'
import { Chord, ChordLyricsPair } from 'chordsheetjs'
import { useChords } from '@/composables'

export default function useSongsheetParser (source) {
  // The parser to use for the source document (ChordPro, ChordsOverWords, UltimateGuitar)
  const parser = computed(() => detectFormat(toValue(source)))

  // The last error that occurred while parsing the source document
  const error = ref()

  // The number of steps to transpose
  const transpose = ref(0)

  // The capo position
  const capo = computed({
    get: () => Number(song.value.capo || 0),
    set: (to) => {
      const from = Number(song.value.capo || 0)
      song.value = song.value.transpose(from - to).setCapo(to)
    }
  })

  // The parsed songsheet as a `Song` object from ChordSheetJS
  const song = ref()

  // The chords used in the song
  const chords = useChords(song)

  // The concert key of the song
  const key = computed(() => song.value?.metadata.calculateKeyFromCapo())

  // Transpose the song when the transpose value changes
  watch(transpose, (to, from) => {
    song.value = song.value?.transpose(to - from)
  })

  // Parse the song when the source changes. This uses `watchEffect` instead of `computed` so we
  // can keep the previously parsed song if it fails.
  watchEffect(() => {
    try {
      song.value = normalize(parser.value?.parse(toValue(source)))
      error.value = null // parsing succeeded, so clear last error
    } catch (e) {
      error.value = e
      return null
    }
  })

  // Set a default key if the song doesn't have one
  watchEffect(() => {
    if (!song.value || song.value.key) return
    song.value = song.value.setKey(guessKey(chords.value))
  })

  return { song, chords, error, parser, transpose, capo, key }
}

// FIXME: Replace this with something more intelligent
export function guessKey (chords) {
  return chords[0]?.toString()
}

function normalize (song) {
  return song?.mapItems((item) => {
    if (item instanceof ChordLyricsPair) {
      const chords = Chord.parse(item.chords.trim())?.normalize(song.key, { normalizeChordSuffix: true })?.toString() || item.chords
      return item.set({ chords })
    }

    return item
  })
}
