import guitar from "@tombatossals/chords-db/lib/guitar.json";
import ukulele from "@tombatossals/chords-db/lib/ukulele.json";
import { Chord, ChordDefinition } from "chordsheetjs";

export enum Instrument {
  Guitar = "guitar",
  Ukulele = "ukulele",
}

export type ChordPositionData = {
  frets: number[];
  fingers: number[];
  barres: number[];
  baseFret: number;
  capo?: boolean;
  midi?: number[];
}

export type ChordDefinitionData = {
  key: string;
  suffix: string;
  positions: ChordPositionData[];
};

export type Keys = "C" | "Csharp" | "Db" | "D" | "Dsharp" | "Eb" | "E" | "F" | "Fsharp" | "Gb" | "G" | "Gsharp" | "Ab" | "A" | "Asharp" | "Bb" | "B";

type InstrumentData = {
  main: {
    strings: number;
    fretsOnChord: number;
    name: string;
    numberOfChords: number;
  };
  tunings: Record<string, string[]>,
  keys: string[];
  suffixes: string[];
  chords: { [K in Keys]?: ChordDefinitionData[] }
};

type InstrumentDatabase = {
  [K in Instrument]: InstrumentData;
};

export default class ChordData {
  static db: InstrumentDatabase = {
    [Instrument.Guitar]: guitar,
    [Instrument.Ukulele]: ukulele
  };

  static suffixAliases: Record<string, string> = {
    "": "major",
  };

  static keyAliases: { [K in Keys]?: Keys } = {
    "Csharp": "Db",
    "Dsharp": "Eb",
    "Fsharp": "Gb",
    "Gsharp": "Ab",
    "Asharp": "Bb",

    "Db": "Csharp",
    "Eb": "Dsharp",
    "Gb": "Fsharp",
    "Ab": "Gsharp",
    "Bb": "Asharp",
  }

  static translate(string: string): { key: Keys, suffix: string } {
    const chord = Chord.parse(string)!;
    let key = chord.root!.note;
    const modifier = chord.root!.modifier;
    let suffix = chord.suffix;

    // Normalize modifier
    if (modifier === "#") key = key.replace(modifier, "sharp");

    // Aliases
    suffix = suffix ? this.suffixAliases[suffix] || suffix : "major";

    return { key: key as Keys, suffix };
  }

  static find(chord: string, instrument = Instrument.Guitar, position = 0) {
    const { key, suffix } = this.translate(chord);

    const chordData = this.findChordData(key, instrument);
    const suffixData = chordData?.find((c: ChordDefinitionData) => c.suffix === suffix);
    const positionData = suffixData?.positions[position];

    if (positionData) {
      return new this(positionData);
    }
  }

  static findChordData(key: Keys, instrument = Instrument.Guitar) {
    const chords = this.db[instrument].chords
    return chords[key] || chords[this.keyAliases[key]!];
  }

  // https://martijnversluis.github.io/ChordSheetJS/classes/ChordDefinition.html
  static fromDefinition(definition: ChordDefinition) {
    return new this({
      barres: [],
      baseFret: definition.baseFret,
      frets: definition.frets.map(fret => {
        if (typeof fret === "number") {
          return fret
        } else if (fret === "0") {
          return 0;
        } else {
          return -1;
        }
      }),
      fingers: definition.fingers,
    })
  }

  data: ChordPositionData;

  constructor(data: ChordPositionData) {
    this.data = data;
  }

  get strings() {
    return this.data.frets.length;
  }

  get fingerings(): [number, number | 'x', number | undefined][] {
    // Array of string numbers from top to bottom, e.g. [6, 5, 4, 3, 2, 1]
    const strings = Array.from(
      { length: this.strings },
      (_, i) => i + 1,
    ).reverse();

    return strings.map((stringNum, i) => {
      let fret: number | "x" = this.data.frets[i];
      if (fret === -1) fret = "x";
      const finger = this.data.fingers[i];
      return [stringNum, fret as number | 'x', finger > 0 ? finger : undefined];
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

// Map suffixes to normalized version
[ukulele, guitar].forEach((instrument) => {
  instrument.suffixes.forEach((value) => {
    const noRoot = value.split("/")[0];
    const normalized = Chord.parse("C" + noRoot)?.normalize(null, { normalizeSuffix: true })?.suffix;
    if (normalized && normalized !== noRoot) ChordData.suffixAliases[normalized] = noRoot;
  });
});
