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
    // Array of string numbers from top to bottom, e.g. [6, 5, 4, 3, 2, 1]
    const strings = Array.from({ length: this.strings }, (_, i) => i + 1).reverse()

    return strings.map((string, i) => {
      const fret = this.data.frets[i]
      const finger = this.data.fingers[i]
      return [string, fret >= 0 ? fret : 'x', finger > 0 ? finger : null]
    })
  }

  get barres () {
    return this.data.barres.map(fret => {
      // Get all the strings that could possibly be barred
      const possibleStrings = this.fingerings.filter(f => f[1] >= fret)

      // Which finger touches the most strings?
      const finger = mode(possibleStrings.map(s => s[2]).filter(Boolean))

      const strings = possibleStrings.filter(s => s[2] === finger).map(s => s[0])

      const fromString = strings[0]
      const toString = strings[strings.length - 1]
      return { fret, fromString, toString }
    })
  }
}

function mode (arr) {
  return [...arr].sort((a, b) => {
    return arr.filter(v => v === a).length - arr.filter(v => v === b).length
  }).pop()
}
