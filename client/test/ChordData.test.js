import ChordData from '@/ChordData'
import { Chord } from 'chordsheetjs'
import { describe, expect, test } from 'vitest'

test('C', () => {
  const data = ChordData.find(Chord.parse('C'))
  expect(data.strings).toEqual(6)
  expect(data.fingerings).toEqual([
    [6, 'x', null],
    [5, 3, 3],
    [4, 2, 2],
    [3, 0, null],
    [2, 1, 1],
    [1, 0, null]
  ])
  expect(data.barres).toEqual([])
});

['guitar', 'ukulele'].forEach(instrument => {
  describe(instrument, () => {
    ['C', 'C#', 'Db', 'D', 'D#', 'Eb', 'E', 'F', 'F#', 'Gb', 'G', 'G#', 'Ab', 'A', 'A#', 'Bb', 'B'].forEach(chordName => {
      test(chordName, () => {
        const chord = Chord.parse(chordName)
        const data = ChordData.find(chord, instrument)
        expect(data).not.toBeUndefined()
      })
    })
  })
})
