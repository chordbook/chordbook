import { Controller } from "@hotwired/stimulus"
import detectFormat from "../lib/detect_format"
import ChordSheetJS from "chordsheetjs"

export default class extends Controller {
  static targets = ["title", "subtitle", "body", "metadata"]

  connect() {
    this.update();
  }

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

  update() {
    // FIXME: input gets parsed here and in SongbookController. Can they share?
    const input = this.bodyTarget.value
    const song = window.song = detectFormat(input).parse(input)

    const { title, subtitle, artist } = song.metadata

    if(title) this.titleTarget.value = title
    if(subtitle || artist) this.subtitleTarget.value = subtitle || artist

    this.metadataTarget.value = JSON.stringify(song.metadata)
  }
}
