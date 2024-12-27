import ChordData from "@/ChordData";
import { ChordDefinition } from "chordsheetjs";
import { describe, expect, test } from "vitest";

test("C", () => {
  const data = ChordData.find("C")!;
  expect(data.strings).toEqual(6);
  expect(data.fingerings).toEqual([
    [6, "x", null],
    [5, 3, 3],
    [4, 2, 2],
    [3, 0, null],
    [2, 1, 1],
    [1, 0, null],
  ]);
  expect(data.barres).toEqual([]);
});

["guitar", "ukulele"].forEach((instrument) => {
  describe(instrument, () => {
    [
      "C",
      "C#",
      "Db",
      "D",
      "D#",
      "Eb",
      "E",
      "F",
      "F#",
      "Gb",
      "G",
      "G#",
      "Ab",
      "A",
      "A#",
      "Bb",
      "B",
    ].forEach((chordName) => {
      test(chordName, () => {
        const data = ChordData.find(chordName, instrument);
        expect(data).not.toBeUndefined();
      });
    });
  });
});

describe('fromDefinition', () => {
  test('C7', () => {
    const definition = ChordDefinition.parse('C7 base-fret 1 frets x 3 2 3 1 0')
    const data = ChordData.fromDefinition(definition)

    expect(data.strings).toEqual(6);
    expect(data.fingerings).toEqual([
      [6, "x", null],
      [5, 3, null],
      [4, 2, null],
      [3, 3, null],
      [2, 1, null],
      [1, 0, null],
    ]);
    expect(data.barres).toEqual([]);
  });

  test('D7', () => {
    const definition = ChordDefinition.parse('D7 base-fret 3 frets x 3 2 3 1 x')
    const data = ChordData.fromDefinition(definition)

    expect(data.strings).toEqual(6);
    expect(data.baseFret).toEqual(3);
    expect(data.fingerings).toEqual([
      [6, "x", null],
      [5, 3, null],
      [4, 2, null],
      [3, 3, null],
      [2, 1, null],
      [1, 'x', null],
    ]);
    expect(data.barres).toEqual([]);
  });

  test('E9', () => {
    const definition = ChordDefinition.parse('E9 base-fret 7 frets 0 1 3 3 0 0')
    const data = ChordData.fromDefinition(definition)

    expect(data.strings).toEqual(6);
    expect(data.baseFret).toEqual(7);
    expect(data.fingerings).toEqual([
      [6, 0, null],
      [5, 1, null],
      [4, 3, null],
      [3, 3, null],
      [2, 0, null],
      [1, 0, null],
    ]);
    expect(data.barres).toEqual([]);
  });
})
