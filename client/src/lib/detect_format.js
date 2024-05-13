import {
  ChordProParser,
  ChordsOverWordsParser,
  UltimateGuitarParser,
} from "chordsheetjs";

const PARSERS = [
  {
    pattern: /\[(Verse|Chorus)/i,
    parser: () => new UltimateGuitarParser({ preserveWhitespace: false }),
  },
  {
    pattern: /{\w+:.*|\[[A-G].*\]/i,
    parser: () => new ChordProParser(),
  },
  {
    pattern: /.*/,
    parser: () => new ChordsOverWordsParser({ preserveWhitespace: false }),
  },
];

export default function detectFormat(source) {
  if (!source) return;
  return PARSERS.find(({ pattern }) => source.match(pattern))?.parser();
}
