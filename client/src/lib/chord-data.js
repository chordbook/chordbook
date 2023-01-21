import guitar from '@tombatossals/chords-db/lib/guitar.json'
import ukulele from '@tombatossals/chords-db/lib/ukulele.json'

const instruments = { guitar, ukulele }

const keyAliases = {
  Asharp: 'Bb',
  Csharp: 'Db',
  Dsharp: 'Eb',
  Fsharp: 'Gb',
  Gsharp: 'Ab'
}

const suffixAliases = {
  '': 'major',
  m: 'minor',
  '+': 'aug'
}

export default class ChordData {
  static translate (chord) {
    let key = chord.root.note
    let modifier = chord.root.modifier
    let suffix = chord.suffix

    // Normalize and append modifier to key
    if (modifier === '#') modifier = 'sharp'
    if (modifier) key = key + modifier

    // Aliases
    key = keyAliases[key] || key
    suffix = suffix ? suffixAliases[suffix] || suffix : 'major'

    return { key, suffix }
  }

  static find (chord, instrument = 'guitar', position = 0) {
    const { key, suffix } = this.translate(chord)

    const chordData = instruments[instrument].chords[key]
    const suffixData = chordData?.find(c => c.suffix === suffix)
    const positionData = suffixData?.positions[position]

    if (positionData) {
      return new this(positionData)
    }
  }

  constructor (data) {
    this.data = data
  }

  get strings () {
    return this.data.frets.length
  }

  get fingerings () {
    let string = this.strings
    return this.data.frets.map(fret => [string--, fret >= 0 ? fret : 'x'])
  }

  get barres () {
    return this.data.barres.map(fret => {
      const fromString = this.strings - this.data.frets.findIndex(f => f >= fret)
      const toString = this.data.frets.slice().reverse().findIndex(f => f >= fret) + 1
      return { fret, fromString, toString }
    })
  }
}
