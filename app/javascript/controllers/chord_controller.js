import { Controller } from "@hotwired/stimulus"
import * as vexchords from "vexchords";

import guitar from '@tombatossals/chords-db/lib/guitar.json';
import ukulele from '@tombatossals/chords-db/lib/ukulele.json';

const instruments = window.instruments = {guitar, ukulele}

const keyAliases = {
  "Asharp": "Bb",
  "Db": "Csharp",
  "Dsharp": "Eb",
  "Gb": "Fsharp"
}

const aliases = {
  '': 'major',
  'm': 'minor',
  '+': 'aug'
}

export default class extends Controller {
  static targets = ["name", "diagram"]

  connect() {
    this.chord = this.find(this.name)
    if(this.chord) {
      this.position = this.chord.positions[this.element.dataset.position || 0]
      this.nameTarget.innerText = this.name
      this.diagramTarget.replaceChildren(this.generate())
    } else {
      // No chord
      console.log("No chord found", this.name)
      this.element.remove();
    }
  }

  generate() {
    const el = document.createElement('div');

    vexchords.draw(el, {
      chord: this.fingerings,
      position: this.position.baseFret,
      barres: this.barres
    }, {
      numStrings: this.instrument.main.strings,
      numFrets: 4,
      showTuning: false,
      width: 50,
      height: 65,
    });

    return el.children[0];
  }

  get name() {
    return this.element.dataset.name;
  }

  get instrument() {
    return instruments[this.element.dataset.instrument || "guitar"]
  }

  get fingerings() {
    let string = this.instrument.main.strings
    return this.position.frets.map(fret => [string--, fret >= 0 ? fret : 'x'])
  }

  get barres() {
    return this.position.barres.map(fret => {
      const fromString = this.instrument.main.strings - this.position.frets.findIndex(f => f >= fret);
      const toString = this.position.frets.slice().reverse().findIndex(f => f >= fret) + 1
      return { fret, fromString, toString }
    })
  }

  get frets() {
    // Return copy of frets reversed
    return this.position.frets.slice().reverse()
  }

  find(name) {
    let [chord, key, sign, suffix] = name.match(/([A-G])([#b]?)(.*)/) || []

    if(!chord) return;

    if(sign == "#") sign = "sharp"
    if(sign) key = key + sign

    key = keyAliases[key] || key
    suffix = aliases[suffix] || suffix

    return this.instrument.chords[key].find(chord => chord.suffix == suffix)
  }
}
