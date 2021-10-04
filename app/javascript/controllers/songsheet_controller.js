import { Controller } from "stimulus"
import ChordSheetJS from "chordsheetjs"

export default class extends Controller {
  static values = {
    format: String
  }

  static parsers = {
    chordpro: new ChordSheetJS.ChordProParser(),
    chordsheet: new ChordSheetJS.ChordSheetParser({preserveWhitespace: false}),
    ultimate: new ChordSheetJS.UltimateGuitarParser({preserveWhitespace: false}),
  }

  initialize() {
    this.parsed = this.constructor.parsers[this.format].parse(this.source)
  }

  connect() {
    const output = new ChordSheetJS.HtmlDivFormatter().format(this.parsed)
    this.element.innerHTML = output
    // document.getElementById('chords').replaceChildren(...chords.guitar.forSong(parsed).map(chord => {
    //   let diagram = new ChordDiagram(chord)
    //   return diagram.generate()
    // }));
  }

  get source() {
    return this.element.innerHTML
  }

  get format() {
    return this.formatValue || detectFormat(this.source);
  }
}

const HEURISTICS = {
  ultimate: /\[(Verse.*|Chorus)\]/i,
  chordpro: /\[[A-G].*\]/i,
  chordsheet: /.*/
}

function detectFormat(source) {
  for(const name in HEURISTICS) {
    if(source.match(HEURISTICS[name])) return name;
  }
}
