import { Controller } from "@hotwired/stimulus"
import ChordSheetJS from "chordsheetjs"

export default class extends Controller {
  static targets = ["source", "output", "chords"]

  static parsers = {
    chordpro: new ChordSheetJS.ChordProParser(),
    chordsheet: new ChordSheetJS.ChordSheetParser({preserveWhitespace: false}),
    ultimate: new ChordSheetJS.UltimateGuitarParser({preserveWhitespace: false}),
  }

  initialize() {
    this.song = this.constructor.parsers[this.format].parse(this.source)
  }

  connect() {
    this.outputTarget.innerHTML = new ChordSheetJS.HtmlDivFormatter().format(this.song)

    const chordTemplate = this.chordsTarget.querySelector('template');

    this.chordsTarget.replaceChildren(...this.chords.map(chord => {
      let node = chordTemplate.content.cloneNode(true).firstElementChild;
      node.dataset.name = chord
      return node
    }));
  }

  get source() {
    return this.sourceTarget.innerHTML
  }

  get format() {
    return detectFormat(this.source);
  }

  // Return names of chords used
  get chords() {
    let chords = []
    this.song.lines.forEach(line => {
      line.items.forEach(item => {
        if(item.chords && chords.indexOf(item.chords) == -1) {
          chords.push(item.chords)
        }
      })
    })
    return chords
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
