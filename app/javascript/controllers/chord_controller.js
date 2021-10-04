import { Controller } from "@hotwired/stimulus"
import * as vexchords from "vexchords";

import guitar from '@tombatossals/chords-db/lib/guitar.json';

const aliases = {
  '': 'major',
  'm': 'minor'
}

export default class extends Controller {
  static targets = ["name", "diagram"]

  connect() {
    this.chord = this.find(this.name).positions[0];
    this.nameTarget.innerText = this.name
    this.diagramTarget.replaceChildren(this.generate())
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
    return this.chord.frets.reverse().map(fret => [string++, fret >= 0 ? fret : 'x'])
  }

  find(name) {
    let [_, key, suffix] = name.match(/([A-G][#b]?)(.*)/)
    if(aliases[suffix]) suffix = aliases[suffix]
    return guitar.chords[key].find(chord => chord.suffix == suffix)
  }
}
