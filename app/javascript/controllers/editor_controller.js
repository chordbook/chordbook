import { Controller } from "@hotwired/stimulus"
import detectFormat from "../lib/detect_format"
import ChordSheetJS from "chordsheetjs"

export default class extends Controller {
  static targets = ["title", "subtitle", "body"]

  paste(e) {
    // Let paste do it's thing, but then convert the input to chordpro
    setTimeout(() => this.convert(), 1)
  }

  convert() {
    const input = this.bodyTarget.value
    const parser = detectFormat(input)

    // No need to convert if it's already in chordpro
    if(parser instanceof ChordSheetJS.ChordProParser) return

    const song = parser.parse(input)
    const output = new ChordSheetJS.ChordProFormatter().format(song)
    this.bodyTarget.value = output
  }
}
