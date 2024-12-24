<script setup>
import MetadataChip from "@/components/MetadataChip.vue";
import { componentFor } from "@/components/ChordSheet";
import { Song } from "chordsheetjs";
import { formatArray } from "@/util";
import { useThemeStore } from "@/stores";

defineProps({
  song: {
    type: Song,
    required: true,
  },
  capo: {
    type: Number,
    default: 0,
  },
});

const theme = useThemeStore();
</script>

<template>
  <div class="themed flex flex-col" :data-font-size="theme.fontSize">
    <div
      class="order-2 md:order-1 flex flex-wrap md:flex-nowrap gap-2 md:gap-3 items-center md:items-center border-b border-slate-300 dark:border-slate-800 py-2"
    >
      <slot name="album" />

      <div class="flex flex-col sm:flex-row sm:items-baseline gap-x-1">
        <h1 class="text-xl md:text-2xl mr-1 truncate">
          {{ song.title }}
        </h1>

        <slot name="artist">
          <h2 v-if="song.subtitle" class="my-1 text-base">
            {{ song.subtitle }}
          </h2>
          <h2 v-if="song.artist" class="my-1">
            <span class="text-muted">by</span> {{ formatArray(song.artist) }}
          </h2>
        </slot>
      </div>
      <div
        :id="`${$attrs.id}-key-metadata`"
        class="w-full md:w-auto md:ml-auto flex flex-row gap-x-1"
      >
        <MetadataChip name="Key">
          <span class="chord pr-0">{{
            song.metadata.get("_key") || song.key
          }}</span>
        </MetadataChip>
        <MetadataChip v-if="song.capo > 0" name="Capo" :value="song.capo" />
        <MetadataChip v-else name="No capo" />
      </div>
    </div>
    <div
      v-if="$slots.media"
      class="z-10 order-1 md:sticky md:h-0 top-4 right-0 -m-4 mb-0 pb-4 md:p-0 md:m-0"
    >
      <slot name="media" />
    </div>
    <div class="body order-3">
      <div
        v-for="({ type, lines }, i) in song.paragraphs"
        :key="i"
        :class="type + ' paragraph'"
      >
        <template v-for="(line, j) in lines" :key="j">
          <div v-if="line.hasRenderableItems()" class="row">
            <template v-for="(item, k) in line.items" :key="k">
              <component
                :is="componentFor(item)"
                v-if="item.isRenderable()"
                :item="item"
              />
            </template>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<style>
.body {
  counter-reset: verse;
  @apply leading-tight max-w-max;
}

.paragraph {
  @apply break-inside-avoid my-6 scroll-m-6 snap-end;
}

.tab {
  @apply whitespace-pre overflow-x-auto text-rel-2xs md:text-rel-xs font-mono text-slate-600 dark:text-slate-400;
}

.row {
  @apply flex flex-wrap relative break-inside-avoid;
}

.column {
  @apply flex flex-col;
}

.tag,
.chorus:before,
.verse::before {
  @apply font-semibold text-rel-xs text-muted uppercase break-after-avoid mb-2 block;
}

.annotation,
.chord,
.lyrics {
  @apply whitespace-pre-wrap inline-block;
}

.annotation {
  @apply text-muted italic;
}

.lyrics {
  @apply sm:text-rel-lg mb-1;
}

.chord {
  @apply text-indigo-800 dark:text-indigo-500 font-semibold;
}

.annotation,
.chord,
.literal {
  @apply text-rel-sm leading-none;
}

.chorus {
  @apply bg-slate-100 dark:bg-slate-900 rounded-lg p-6 pt-4;
}

*:not(.chorus) + .chorus::before {
  content: "Chorus";
}

.chorus:has(+ .chorus) {
  @apply mb-0 pb-3 rounded-b-none;
}

.chorus + .chorus {
  @apply mt-0 pt-3 rounded-t-none;
}

.verse::before {
  counter-increment: verse;
  content: "Verse " counter(verse);
}

/* Hide implicit labels if explicit label is present */
.verse:has(.start_of_verse)::before,
.chorus:has(.start_of_chorus)::before {
  display: none;
}

.annotation:after,
.chord:after,
.lyrics:after {
  content: "\200b";
}

.themed[data-font-size="sm"] {
  @apply text-rel-sm lg:text-rel-base;
}

.themed[data-font-size="md"] {
  @apply text-rel-base lg:text-rel-lg;
}

.themed[data-font-size="lg"] {
  @apply text-rel-lg lg:text-rel-xl;
}

.themed[data-font-size="xl"] {
  @apply text-rel-xl lg:text-rel-2xl;
}

.themed[data-font-size="2xl"] {
  @apply text-rel-2xl lg:text-rel-3xl;
}

.themed[data-font-size="3xl"] {
  @apply text-rel-3xl lg:text-rel-4xl;
}
</style>
