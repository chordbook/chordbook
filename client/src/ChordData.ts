import guitar from "@tombatossals/chords-db/lib/guitar.json";
import ukulele from "@tombatossals/chords-db/lib/ukulele.json";
import { Chord, ChordDefinition } from "chordsheetjs";

type ChordDefinitionData = typeof guitar["chords"]["C"][0];

type ChordPositionData = {
  frets: (number | '0' | '-1' | 'N' | 'x')[];
  fingers: number[];
  barres: number[];
  baseFret: number;
}

const instruments: Record<string, any> = { guitar, ukulele };

const keyAliases: Record<string, string> = {
  Db: "Csharp",
  Eb: "Dsharp",
  Gb: "Fsharp",
  Ab: "Gsharp",
  Bb: "Asharp",
};

// Map inverse of aliases
Object.keys(keyAliases).forEach((key) => (keyAliases[keyAliases[key]] = key));

const suffixAliases: Record<string, string> = {
  "": "major",
};

// Map suffixes to normalized version
ukulele.suffixes.forEach((value) => {
  const key = Chord.parse("C" + value)?.normalize()?.suffix;
  if (key && key !== value) suffixAliases[key] = value;
});

export default class ChordData {
  data: ChordPositionData;

  static translate(chord: Chord) {
    let key = chord.root!.note;
    const modifier = chord.root!.modifier;
    let suffix = chord.suffix;

    // Normalize modifier
    if (modifier === "#") key = key.replace(modifier, "sharp");

    // Aliases
    suffix = suffix ? suffixAliases[suffix] || suffix : "major";

    return { key, suffix };
  }

  static find(chord: string, instrument = "guitar", position = 0) {
    const { key, suffix } = this.translate(Chord.parse(chord)!);

    const chordData = this.findChordData(key, instrument);
    const suffixData = chordData?.find((c: ChordDefinitionData) => c.suffix === suffix);
    const positionData = suffixData?.positions[position];

    if (positionData) {
      return new this(positionData);
    }
  }

  static findChordData(key: string, instrument = "guitar") {
    return (
      instruments[instrument].chords[key] ||
      instruments[instrument].chords[keyAliases[key]]
    );
  }

  // https://martijnversluis.github.io/ChordSheetJS/classes/ChordDefinition.html
  static fromDefinition(definition: ChordDefinition) {
    return new this({
      barres: [],
      baseFret: definition.baseFret,
      frets: definition.frets,
      fingers: definition.fingers,
    })
  }

  constructor(data: ChordPositionData) {
    this.data = data;
  }

  get strings() {
    return this.data.frets.length;
  }

  get fingerings() {
    // Array of string numbers from top to bottom, e.g. [6, 5, 4, 3, 2, 1]
    const strings = Array.from(
      { length: this.strings },
      (_, i) => i + 1,
    ).reverse();

    return strings.map((string, i) => {
      let fret = this.data.frets[i];
      if (fret === -1) fret = "x";
      const finger = this.data.fingers[i];
      return [string, fret, finger > 0 ? finger : null];
    });
  }

  get barres() {
    return (this.data.barres ?? []).map((fret) => {
      // Get all the strings that could possibly be barred
      const possibleStrings = this.fingerings.filter((f) => typeof f[1] === "number" && f[1] >= fret);

      // Which finger touches the most strings?
      const finger = mode(possibleStrings.map((s) => s[2]).filter(Boolean));

      const strings = possibleStrings
        .filter((s) => s[2] === finger)
        .map((s) => s[0]);

      const fromString = strings[0];
      const toString = strings[strings.length - 1];
      return { fret, fromString, toString };
    });
  }

  get baseFret() {
    return this.data.baseFret;
  }
}

function mode<T>(arr: T[]): T | undefined {
  return [...arr].sort((a, b) => {
    return (
      arr.filter((v) => v === a).length - arr.filter((v) => v === b).length
    );
  }).pop();
}
