import { ref, computed, watchEffect, toValue } from 'vue'
import detectFormat from '@/lib/detect_format'
import { Chord, ChordLyricsPair } from 'chordsheetjs'
import useChords from '@/composables/useChords'

export default function useSongsheetParser (source) {
  const parser = computed(() => detectFormat(toValue(source)))
  const error = ref()
  const song = ref()
  const chords = useChords(song)
  const key = computed(() => song.value?.key ?? chords.value[0]?.toString())

  // Using watchEffect instead of computed to try to parse the source whenever it changes
  // so we can keep the previously parsed song if it fails.
  watchEffect(() => {
    try {
      song.value = normalize(parser.value?.parse(toValue(source)))

      // parsing succeeded, so clear last error
      error.value = null
    } catch (e) {
      error.value = e
      return null
    }
  })

  return { song, key, chords, error, parser }
}

function normalize (song) {
  return song?.mapItems((item) => {
    if (item instanceof ChordLyricsPair) {
      const chords = Chord.parse(item.chords.trim())?.normalize()?.toString() || item.chords
      return item.set({ chords })
    }

    return item
  })
}
