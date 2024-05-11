<script setup>
import AlbumItem from "./AlbumItem.vue";
import ArtistCard from "./ArtistCard.vue";
import ArtistItem from "./ArtistItem.vue";
import SetlistCard from "./SetlistCard.vue";
import SetlistItem from "./SetlistItem.vue";
import SongsheetItem from "./SongsheetItem.vue";
import TrackItem from "./TrackItem.vue";
import { computed } from "vue";

const components = {
  item: {
    Album: AlbumItem,
    Artist: ArtistItem,
    Setlist: SetlistItem,
    Songsheet: SongsheetItem,
    Track: TrackItem,
  },
  card: {
    Album: AlbumItem,
    Artist: ArtistCard,
    Setlist: SetlistCard,
    Songsheet: SongsheetItem,
    Track: TrackItem,
  },
};

const props = defineProps({
  type: {
    type: String,
    required: true,
  },
  format: {
    type: String,
    default: "item",
    validator(value) {
      return ["item", "card"].includes(value);
    },
  },
});

const component = computed(() => {
  const component = components[props.format][props.type];
  if (!component)
    throw new Error(`Unknown type: ${props.type} - #{props.format}`);
  return component;
});
</script>

<template>
  <component :is="component" v-bind="$attrs" />
</template>
