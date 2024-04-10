import { ref, watch, computed, watchEffect, toValue } from 'vue'
import detectFormat from '@/lib/detect_format'
import { Chord, ChordLyricsPair } from 'chordsheetjs'
import { useChords } from '@/composables'

export default function useSongsheetParser (source) {
  const parser = computed(() => detectFormat(toValue(source)))
  const error = ref()
  const transpose = ref(0)
  const capo = computed({
    get: () => Number(song.value.capo || 0),
    set: (to) => {
      const from = Number(song.value.capo || 0)
      song.value = song.value.transpose(from - to).setCapo(to)
    }
  })
  const song = ref()
  const chords = useChords(song)
  const key = computed(() => song.value?.metadata.calculateKeyFromCapo())

  watch(transpose, (to, from) => {
    song.value = song.value?.transpose(to - from)
  })

  // Using watchEffect instead of computed so we can keep the previously parsed song if it fails.
  watchEffect(() => {
    try {
      song.value = normalize(parser.value?.parse(toValue(source)))
      error.value = null // parsing succeeded, so clear last error
    } catch (e) {
      error.value = e
      return null
    }
  })

  watchEffect(() => {
    if (song.value && !song.value.key) {
      song.value = song.value.setKey(guessKey(chords.value))
    }
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
