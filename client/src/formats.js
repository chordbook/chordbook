import ChordSheetJS from 'chordsheetjs'

const FORMATS = [
  {
    name: 'UltimateGuitar',
    pattern: /\[(Verse.*|Chorus)\]/i,
    parser: new ChordSheetJS.UltimateGuitarParser({ preserveWhitespace: false })
  },
  {
    name: 'ChordPro',
    pattern: /{\w+:.*|\[[A-G].*\]/i,
    parser: new ChordSheetJS.ChordProParser()
  },
  {
    name: 'ChordSheet',
    pattern: /.*/,
    parser: new ChordSheetJS.ChordSheetParser({ preserveWhitespace: false })
  }
]

export function guess (source) {
  if (!source) return
  return FORMATS.find(({ pattern }) => source.match(pattern))
}

// Export object of formats indexed by name
export default Object.fromEntries(FORMATS.map(format => [format.name, format]))
