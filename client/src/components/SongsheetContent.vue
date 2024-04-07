<script setup>
import ChordLyricsPair from '@/components/ChordLyricsPair.vue'
import SongSheetComment from '@/components/SongSheetComment.vue'
import { Song } from 'chordsheetjs'
import { formatArray } from '@/util'
import { useThemeStore } from '@/stores'

defineProps({
  song: {
    type: Song,
    required: true
  }
})

const theme = useThemeStore()

function componentFor (item) {
  return [ChordLyricsPair, SongSheetComment].find(c => c.for(item))
}
</script>

<template>
  <div
    class="songsheet-content themed"
    :data-font-size="theme.fontSize"
  >
    <div class="mb-6 text-base">
      <slot name="title">
        <h1 class="text-xl md:text-2xl my-1">
          {{ song.title }}
        </h1>
        <h2
          v-if="song.subtitle"
          class="my-1"
        >
          {{ song.subtitle }}
        </h2>
        <h2
          v-if="song.artist"
          class="my-1"
        >
          <span class="text-muted">by</span> {{ formatArray(song.artist) }}
        </h2>
      </slot>
    </div>

    <div
      v-if="song.capo"
      class="capo my-4"
    >
      Capo {{ song.capo }}
    </div>

    <div
      v-for="({ type, lines }, i) in song.paragraphs"
      :key="i"
      :class="type + ' paragraph'"
    >
      <template
        v-for="(line, j) in lines"
        :key="j"
      >
        <div
          v-if="line.hasRenderableItems()"
          class="row"
        >
          <template
            v-for="(item, k) in line.items"
            :key="k"
          >
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
</template>

<style>
.songsheet-content {
  counter-reset: verse;
  @apply leading-tight;
}

.paragraph {
  @apply break-inside-avoid my-6 scroll-m-6 snap-end;
}

.row {
  @apply flex flex-wrap relative break-inside-avoid;
}

.column {
  @apply flex flex-col;
}

.comment, .chorus:before, .verse::before, .capo {
  @apply font-semibold text-rel-sm text-zinc-600 dark:text-zinc-500 break-after-avoid;
}

.chord, .lyrics {
  @apply whitespace-pre;
}

.tab {
  @apply font-mono text-rel-xs;
}

.songsheet-content *:not(.tab) .chord {
  @apply text-indigo-800 dark:text-indigo-500 pr-1 font-semibold;
}

.chorus {
  @apply border-neutral-200 dark:border-neutral-700 pl-4 border-l-4;
}

*:not(.chorus) + .chorus::before {
  content: "Chorus:";
}

.chorus+.chorus {
  @apply mt-0 pt-6;
}

.verse::before {
  counter-increment: verse;
  content: "Verse " counter(verse) ":";
}

.chord:after, .lyrics:after {
  content: '\200b';
}

.chord-diagram {
  width: 40px;
  height: 52px;
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
