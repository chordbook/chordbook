import { Controller } from "@hotwired/stimulus"
import * as vexchords from "vexchords";

import guitar from '@tombatossals/chords-db/lib/guitar.json';

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
    vexchords.draw(el, { chord: this.fingerings }, {
      showTuning: false,
      width: 50,
      height: 60,
    });
    return el.children[0];
  }

  get name() {
    return this.element.dataset.name;
  }

  get fingerings() {
    let string = 1;
    return this.frets.map(fret => [string++, fret >= 0 ? fret : 'x'])
  }

  get frets() {
    // Return copy of frets reversed
    return this.chord.positions[0].frets.slice().reverse()
  }

  find(name) {
    let [chord, key, sign, suffix] = name.match(/([A-G])([#b]?)(.*)/) || []

    if(!chord) return;

    if(sign == "#") sign = "sharp"
    if(sign) key = key + sign

    key = keyAliases[key] || key
    suffix = aliases[suffix] || suffix

    return guitar.chords[key].find(chord => chord.suffix == suffix)
  }
}
