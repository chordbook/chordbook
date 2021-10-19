import guitar from '@tombatossals/chords-db/lib/guitar.json'
import ukulele from '@tombatossals/chords-db/lib/ukulele.json'

const instruments = window.instruments = { guitar, ukulele }

const keyAliases = {
  Asharp: 'Bb',
  Db: 'Csharp',
  Dsharp: 'Eb',
  Gb: 'Fsharp'
}

const aliases = {
  '': 'major',
  m: 'minor',
  '+': 'aug'
}

export default class Chord {
  constructor (name, instrument = 'guitar', position = 0) {
    let [match, key, sign, suffix] = name.match(/([A-G])([#b]?)(.*)/) || []

    if (!match) throw new Error('Not a chord:' + name)

    if (sign === '#') sign = 'sharp'
    if (sign) key = key + sign

    key = keyAliases[key] || key
    suffix = aliases[suffix] || suffix

    const chord = instruments[instrument].chords[key].find(chord => chord.suffix === suffix)
    const data = chord?.positions[position]

    if (!chord || !data) throw new Error('No chord data found: ' + name)

    Object.assign(this, { name, key, sign, suffix, instrument, position, data })
    this.strings = instruments[instrument].main.strings
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
