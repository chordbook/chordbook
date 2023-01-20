<script setup>
import ChordLyricsPair from '@/components/ChordLyricsPair.vue'
import SongSheetComment from '@/components/SongSheetComment.vue'
import ChordDiagram from '@/components/ChordDiagram.vue'

import { ref, computed, watch, onMounted, onUpdated } from 'vue'
import detectFormat from '@/lib/detect_format'
import useSongsheetSettingsStore from '@/stores/songsheet-settings'
import arrify from 'arrify'

const emit = defineEmits(['update:key', 'parse', 'error'])

const props = defineProps({
  source: {
    type: String,
    default: null
  }
})

const output = ref(null) // template ref
const columnWidth = ref(0)
const settings = useSongsheetSettingsStore()
const format = computed(() => detectFormat(props.source))

const parsedSong = computed(() => {
  try {
    // FIXME: somehow \r is getting added by Ace
    const song = format.value?.parse(props.source.replace(/\r\n/gm, '\n'))
    return song.key ? song : song.setKey(guessKey(song))
  } catch (error) {
    console.error(error)
    emit('error', error)
    return null
  }
})

const song = computed(() => parsedSong.value?.transpose(settings.transpose))
const chords = computed(() => chordSet(song.value))
const key = computed(() => song.value?.key)

watch(() => settings.columns, updateColumnWidth)
watch(key, key => emit('update:key', key), { immediate: true })
watch(song, song => emit('parse', song), { immediate: true })

onMounted(updateColumnWidth)
onUpdated(updateColumnWidth)

function componentFor (item) {
  return [ChordLyricsPair, SongSheetComment].find(c => c.for(item))
}

function updateColumnWidth () {
  if (!output.value) return

  output.value.classList.add('content-width')
  requestAnimationFrame(() => {
    columnWidth.value = output.value.offsetWidth + 'px'
    output.value.classList.remove('content-width')
  })
}

function formatArray (args) {
  return new Intl.ListFormat().format(arrify(args))
}

function chordSet (song) {
  const chords = new Set()

  song.lines.forEach(line => {
    line.items.forEach(pair => {
      if (pair.chords) chords.add(pair.chords)
    })
  })

  return chords
}

function guessKey (song) {
  // FIXME: use intelligent key detection
  const [key] = chordSet(song)
  return key
}
</script>

<template>
  <ion-content
    v-if="song"
    :scroll-y="settings.columns == 1"
    :scroll-x="settings.columns == 2"
    fullscreen
  >
    <slot name="top" />
    <div :class="'ion-padding ' + (settings.columns == 1 ? 'single-column' : 'horizontal-columns')">
      <!-- Hidden sprite of chord diagrams -->
      <svg
        hidden
        xmlns="http://www.w3.org/2000/svg"
      >
        <chord-diagram
          v-for="chord in chords"
          :key="chord + settings.instrument"
          :name="chord"
          :instrument="settings.instrument"
        />
      </svg>

      <slot name="header">
        <h1 class="text-xl md:text-2xl my-1">
          {{ song?.title }}
        </h1>
        <div
          v-if="song.artist"
          class="my-1"
        >
          <span class="text-muted">by</span> {{ formatArray(song.artist) }}
        </div>
      </slot>

      <div
        ref="output"
        class="chord-sheet mt-2"
      >
        <div
          v-if="song.capo"
          class="capo my-4"
        >
          Capo {{ song.capo }}
        </div>
        <div
          v-if="song.subtitle"
          class="my-1"
        >
          {{ song.subtitle }}
        </div>

        <div
          v-for="{ type, lines } in song.paragraphs"
          :key="type + JSON.stringify(lines)"
          :class="type + ' paragraph'"
        >
          <template
            v-for="line in lines"
            :key="JSON.stringify(line)"
          >
            <div
              v-if="line.hasRenderableItems()"
              class="row"
            >
              <template
                v-for="item in line.items"
                :key="JSON.stringify(item)"
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
    </div>
    <slot name="footer" />
  </ion-content>
  <ion-footer
    v-if="settings.showChords"
    translucent
  >
    <ion-toolbar translucent>
      <div class="flex gap-2 overflow-x-auto place-content-center pt-2 px-4">
        <div
          v-for="name in chords"
          :key="name"
          class="text-center text-sm"
        >
          <div class="chord">
            {{ name }}
          </div>
          <svg
            class="chord-diagram inline-block"
            xmlns="http://www.w3.org/2000/svg"
            role="image"
            :title="name"
          >
            <use
              :xlink:href="`#chord-${name}`"
              viewBox="0 0 50 65"
            />
          </svg>
        </div>
      </div>
    </ion-toolbar>
  </ion-footer>
</template>

<style>
.horizontal-columns {
  @apply h-full;
  column-count: auto;
  column-width: v-bind(columnWidth);
  min-width: v-bind(columnWidth);
}
.horizontal-columns .column-span-all { column-span: all; }

.single-column .row { flex-wrap: wrap; }

.content-width {
  overflow: auto !important;
  max-width: max-content !important;
  min-width: max-content !important;
  width: max-content !important;
  display: inline-block !important;
  flex-wrap: nowrap !important;
  padding: none !important;
}

.chord-sheet {
  counter-reset: verse;
}

.paragraph {
  @apply leading-tight break-inside-avoid;
}

.paragraph + .paragraph {
  @apply mt-6;
}

.row {
  @apply flex flex-nowrap relative break-inside-avoid;
}

.column {
  @apply flex flex-col
}

.comment, .chorus:before, .verse::before, .capo {
  @apply font-semibold text-sm text-zinc-600 break-after-avoid;
}

.chord, .lyrics {
  @apply whitespace-pre
}

.tab {
  @apply font-mono text-xs;
}

.chord-sheet *:not(.tab) .chord {
  @apply text-indigo-800 dark:text-indigo-300 pr-1 font-medium text-sm;
}

.chorus {
  @apply border-neutral-200 dark:border-neutral-700 pl-4 border-l-4;
}

*:not(.chorus) + .chorus::before {
  content: "Chorus:";
}

.chorus + .chorus {
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
  width: 50px;
  height: 65px;
}
</style>
