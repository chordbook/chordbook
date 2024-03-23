import { Chord } from 'chordsheetjs'
import { computed } from 'vue'

export default function useChords (song) {
  return computed(() => {
    const chords = new Set()

    song.value.lines.forEach(line => {
      line.items.forEach(pair => {
        if (pair.chords) chords.add(pair.chords)
      })
    })

    return Array.from(chords).map(name => Chord.parse(name)).filter(Boolean)
  })
}
