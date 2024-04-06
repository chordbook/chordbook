import { useChords } from '@/composables'
import { Chord, ChordProParser } from 'chordsheetjs'
import { expect, test } from 'vitest'
import { ref } from 'vue'

test('gracefully fails with null', async () => {
  expect(useChords(null).value).toEqual([])
})

test('gracefully fails with null ref', async () => {
  expect(useChords(ref()).value).toEqual([])
})

test('returns chords used in the song', () => {
  const song = new ChordProParser().parse('{title: Hello}\n[C]Hello [G]world [D]!')
  expect(useChords(song).value).toEqual(['C', 'G', 'D'].map(name => Chord.parse(name)))
})

test('works with song ref', () => {
  const song = ref(new ChordProParser().parse('{title: Hello}\n[C]Hello [G]world [D]!'))
  const chords = useChords(song)

  expect(chords.value).toEqual(['C', 'G', 'D'].map(name => Chord.parse(name)))
  song.value = new ChordProParser().parse('{title: Hello}\n[F]Hello [C]world [B]!')
  expect(chords.value).toEqual(['F', 'C', 'B'].map(name => Chord.parse(name)))
})
