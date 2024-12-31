<script lang="ts" setup generic="T extends Album | Artist | Setlist | Songsheet | Track">
import type { Album, Artist, Setlist, Songsheet, Track } from "@/api"

import HorizontalScroller from "./HorizontalScroller.vue";
import AlbumItem from "./AlbumItem.vue";
import ArtistCard from "./ArtistCard.vue";
import ArtistItem from "./ArtistItem.vue";
import SetlistCard from "./SetlistCard.vue";
import SetlistItem from "./SetlistItem.vue";
import SongsheetItem from "./SongsheetItem.vue";

import TrackItem from "./TrackItem.vue";
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

const { items, format = "item" } = defineProps<{
  items: T[]
  format?: "item" | "card";
}>();

function componentFor(item: T) {
  return components[format][item.type]
}
</script>

<template>
  <HorizontalScroller
    :class="{
      'grid-scroll-x touch:[--auto-cols-peek:0.9] touch:main-content-breakout touch:main-content-padding': true,
      'grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4':
        format === 'item',
      'auto-cols-1/2 sm:auto-cols-1/3 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8':
        format === 'card',
    }"
  >
    <component
      v-for="item in items"
      :key="item.id"
      :is="componentFor(item)"
      :format="format"
      v-bind="{ ...item, ...$attrs }"
    />
  </HorizontalScroller>
</template>
