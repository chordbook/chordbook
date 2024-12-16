import { ref, toRef, computed, watchEffect, toValue } from "vue";
import detectFormat from "@/lib/detect_format";
import { Chord, ChordLyricsPair, Key, Tag } from "chordsheetjs";

export default function useSongsheetParser(source, settings = {}) {
  // The parser to use for the source document (ChordPro, ChordsOverWords, UltimateGuitar)
  const parser = computed(() => detectFormat(toValue(source)));

  // The last error that occurred while parsing the source document
  const error = ref();

  // The number of steps to transpose
  const transpose = toRef(settings.transpose ?? 0);

  // The capo position
  const capo = toRef(settings.capo ?? 0);

  // The #/b modifier to apply to the key
  const modifier = toRef(settings.modifier ?? null);

  // The parsed songsheet as a `Song` object from ChordSheetJS
  const originalSong = ref();

  // The final `Song` after transposing, normalizing, etc.
  const song = ref();

  // The chords used in the song
  const chords = computed(() => song.value?.getChords() ?? []);

  // The concert key of the song
  const key = computed(() => {
    const value =
      capo.value === 0
        ? song.value.key
        : song.value?.metadata.calculateKeyFromCapo();
    return Key.wrap(value).useModifier(modifier.value).normalize().toString();
  });

  // Parse the song when the source changes. This uses `watchEffect` instead of `computed` so we
  // can keep the previously parsed song if it fails.
  watchEffect(() => {
    try {
      originalSong.value = parser.value?.parse(toValue(source));
      capo.value = Number(originalSong.value?.capo || 0);
      error.value = null; // parsing succeeded, so clear last error
    } catch (e) {
      error.value = e;
      return null;
    }
  });

  // Normalize the song when it changes. This will normalize the modifier on the key and chords (B# => C),
  // and normalize the suffix on the chords (Bsus4 => Bsus).
  watchEffect(() => {
    if (!originalSong.value) return;

    const capoDelta = Number(originalSong.value.capo || 0) - capo.value;
    let newSong = originalSong.value
      .transpose(transpose.value + capoDelta)
      .setCapo(capo.value);
    if (!newSong.key) newSong = newSong.setKey(guessKey(newSong.getChords()));
    song.value = normalize(
      newSong,
      modifier.value || preferredModifierForKey(newSong.key),
    );
  });

  return {
    originalSong,
    song,
    chords,
    error,
    parser,
    transpose,
    capo,
    key,
    modifier,
  };
}

// FIXME: Replace this with something more intelligent
export function guessKey(chords) {
  return Chord.parse(chords[0])?.root.toString();
}

// Normalize the key and chords to use the given modifier, and normalize chord suffixes
export function normalize(song, modifier) {
  let key = Key.parse(song.key)?.useModifier(modifier).normalize();
  return song.setKey(key).mapItems((item) => {
    if (item instanceof Tag && item.name === "key") {
      key = Key.parse(item.value).normalize();
      return item.set({ value: key.toString() });
    } else if (item instanceof Tag && item.chordDefinition) {
      // Normalize chord names in definitions (e.g. Cmaj7 => Cma7)
      const chord = Chord.parse(item.chordDefinition.name)
      if (chord) {
        item.chordDefinition.name = chord.useModifier(modifier).normalize(key, { normalizeChordSuffix: true }).toString()
      }
    }else if (item instanceof ChordLyricsPair) {
      const chord = Chord.parse(item.chords.trim());

      if (chord) {
        return item.set({
          chords: chord
            .useModifier(modifier)
            .normalize(key, { normalizeChordSuffix: true })
            ?.toString(),
        });
      }
    }
    return item;
  });
}

// The preferred modifier to use for each key
const IMPLICIT_MODIFIER = {
  F: "b",
  G: "#",
  D: "#",
  A: "#",
  E: "#",
  B: "#",
};

export function preferredModifierForKey(key) {
  const wrappedKey = Key.wrap(key);
  return (
    wrappedKey?.modifier ||
    IMPLICIT_MODIFIER[wrappedKey?.toMajor().toString()] ||
    null
  );
}
