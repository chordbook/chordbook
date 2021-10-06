import { Controller } from "@hotwired/stimulus"
import ChordSheetJS from "chordsheetjs"

export default class extends Controller {
  static targets = ["source", "output", "chords"]

  static parsers = {
    chordpro: new ChordSheetJS.ChordProParser(),
    chordsheet: new ChordSheetJS.ChordSheetParser({preserveWhitespace: false}),
    ultimate: new ChordSheetJS.UltimateGuitarParser({preserveWhitespace: false}),
  }

  connect() {
    this.render()
  }

  initialize() {
    this.chordTemplate = this.chordsTarget.querySelector('template')
  }

  render() {
    this.song = this.constructor.parsers[this.format].parse(this.source)
    this.outputTarget.innerHTML = new ChordSheetJS.HtmlDivFormatter().format(this.song)

    this.chords.forEach(chord => {
      const template = this.chordTemplate.content.cloneNode(true).firstElementChild
      template.dataset.name = chord

      this.chordsTargets.forEach(chords => {
        const chord = template.cloneNode(true)
        chord.dataset.instrument = chords.dataset.instrument
        chords.appendChild(chord)
      })
    })
  }

  get source() {
    return this.sourceTarget.value || this.sourceTarget.innerHTML
  }

  get format() {
    return detectFormat(this.source)
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
  chordpro: /{\w+:.*|\[[A-G].*\]/i,
  chordsheet: /.*/
}

function detectFormat(source) {
  for(const name in HEURISTICS) {
    if(source.match(HEURISTICS[name])) return name
  }
}
