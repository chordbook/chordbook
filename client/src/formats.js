import ChordSheetJS from 'chordsheetjs'
import * as OnSong from 'onsong'

function csjsParse (parser) {
  return (source, { transpose }) => {
    let song = parser.parse(source)
    let chords = chordSet(song)
    const key = song.key || guessKey(chords)

    if (transpose) {
      song = song.transpose(transpose)
      chords = chordSet(song)
    }

    const { metadata } = song.metadata

    return { song, key, chords, metadata }
  }
}

function chordSet (song) {
  const chords = new Set()

  song.lines.forEach(line => {
    line.items.forEach(pair => {
      if (pair.chords) chords.add(pair.chords)
    })
  })

  return chords
}

function guessKey (chordSet) {
  // FIXME: use intelligent key detection
  return chordSet.values().next().value
}

const FORMATS = Object.fromEntries([
  {
    name: 'UltimateGuitar',
    pattern: /\[(Verse.*|Chorus)\]/i,
    parse: csjsParse(new ChordSheetJS.UltimateGuitarParser({ preserveWhitespace: false }))
  },
  {
    name: 'ChordPro',
    pattern: /{\w+:.*|\[[A-G].*\]/i,
    parse: csjsParse(new ChordSheetJS.ChordProParser())
  },
  {
    name: 'OnSong',
    pattern: /.*/,
    parse: (source) => {
      const song = OnSong.parse(source)
      // FIXME: key
      // FIXME: transpose

      return { song, metadata: song.metadata }
    }
  },
  {
    name: 'ChordSheet',
    pattern: /.*/,
    parse: csjsParse(new ChordSheetJS.ChordSheetParser({ preserveWhitespace: false }))
  }
].map(format => [format.name, format]))

export function guess (source) {
  if (!source) return
  return Object.values(FORMATS).find(({ pattern }) => source.match(pattern))
}

// Export object of formats indexed by name
export default FORMATS

export function parse (source, format, { transpose } = {}) {
  return FORMATS[format].parse(source, { transpose })
}
