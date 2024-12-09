<script setup>
import ChordSheet from "@/components/ChordSheet/index.vue";
import { Song } from "chordsheetjs";
import { useThemeStore } from "@/stores";

defineProps({
  song: {
    type: Song,
    required: true,
  }
});

const theme = useThemeStore();
</script>

<template>
  <div class="themed flex flex-col" :data-font-size="theme.fontSize">
    <div class="body order-3">
      <div
        v-for="({ type, lines }, i) in song.paragraphs"
        :key="i"
        :class="type + ' paragraph'"
      >
        <template v-for="(line, j) in lines" :key="j">
          <ChordSheet :item="line" />
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
  @apply flex flex-wrap relative;
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
  @apply text-indigo-800 dark:text-indigo-500 font-semibold mr-1;
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
