import ChordSheetJS from 'chordsheetjs'

const PARSERS = [
  {
    pattern: /{\w+:.*|\[[A-G].*\]/i,
    parser: new ChordSheetJS.ChordProParser()
  },
  {
    pattern: /\[(Verse.*|Chorus)\]/i,
    parser: new ChordSheetJS.UltimateGuitarParser({ preserveWhitespace: false })
  },
  {
    pattern: /.*/,
    parser: new ChordSheetJS.ChordSheetParser({ preserveWhitespace: false })
  }
]

export default function detectFormat (source) {
  return PARSERS.find(({ pattern }) => source.match(pattern))?.parser
}
