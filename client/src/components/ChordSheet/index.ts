import ChordLyricsPair from "./ChordLyricsPair.vue";
import Tag from "./Tag.vue";
import Literal from "./Literal.vue";

export { ChordLyricsPair, Tag, Literal };

export function componentFor(item: unknown) {
  return [ChordLyricsPair, Tag, Literal].find((c) => c.for(item));
}
