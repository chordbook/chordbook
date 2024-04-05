import { ref, computed, watchEffect, toValue, reactive } from 'vue'
import detectFormat from '@/lib/detect_format'
import { Chord, ChordLyricsPair } from 'chordsheetjs'
import { useChords } from '@/composables'

export default function useSongsheetParser (source) {
  const parser = computed(() => detectFormat(toValue(source)))
  const error = ref()
  const song = ref()
  const chords = useChords(song)
  const key = computed(() => song.value?.key ?? guessKey(chords.value))
  const transpose = ref(0)
  const capo = ref(0)
  const transposedSong = computed(() => normalize(song.value?.transpose(transpose.value - capo.value)))
  const transposed = reactive({
    key: computed(() => Chord.parse(key.value).transpose(transpose.value, { normalizeChordSuffix: true })),
    song: transposedSong,
    chords: useChords(transposedSong)
  })

  // Using watchEffect instead of computed so we can keep the previously parsed song if it fails.
  watchEffect(() => {
    try {
      const parsed = parser.value?.parse(toValue(source))
      const originalCapo = Number(parsed.capo ?? 0)
      capo.value = originalCapo
      song.value = normalize(parsed.transpose(originalCapo, { normalizeChordSuffix: true }))
      error.value = null // parsing succeeded, so clear last error
    } catch (e) {
      error.value = e
      return null
    }
  })

  return { song, key, chords, error, parser, transpose, capo, transposed }
}

// FIXME: Replace this with something more intelligent
export function guessKey (chords) {
  return chords[0]?.toString()
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
