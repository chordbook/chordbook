<template>
  <ion-content
    v-if="parsed?.song"
    :scroll-y="columns == 1"
    :scroll-x="columns == 2"
    fullscreen
  >
    <slot name="top" />
    <div :class="'ion-padding ' + (columns == 1 ? 'single-column' : 'horizontal-columns')">
      <!-- Hidden sprite of chord diagrams -->
      <svg
        hidden
        xmlns="http://www.w3.org/2000/svg"
      >
        <chord-diagram
          v-for="chord in parsed.chords"
          :key="chord + instrument"
          :name="chord"
          :instrument="instrument"
        />
      </svg>

      <slot name="header">
        <h1 class="text-xl md:text-2xl my-1">
          {{ parsed?.metadata?.title }}
        </h1>
        <div
          v-if="parsed?.metadata?.artist"
          class="my-1"
        >
          <span class="text-muted">by</span> {{ formatArray(parsed.metadata.artist) }}
        </div>
      </slot>

      <div ref="output">
        <component
          :is="renderer"
          :song="parsed.song"
          class="chord-sheet mt-2"
        />
      </div>
    </div>
    <slot name="footer" />
  </ion-content>
  <ion-footer
    v-if="showChords"
    translucent
  >
    <ion-toolbar translucent>
      <div class="flex gap-2 overflow-x-auto place-content-center pt-2 px-4">
        <div
          v-for="name in parsed.chords"
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

<script>
import { parse } from '@/formats'
import ChordSheetJSRenderer from '@/components/renderer/ChordSheetJS.vue'
import OnSongRenderer from '@/components/renderer/OnSong.vue'
import ChordDiagram from '@/components/ChordDiagram.vue'
import arrify from 'arrify'
import useSongsheetSettingsStore from '@/stores/songsheet-settings'
import { mapState } from 'pinia'

export default {
  components: { ChordDiagram },

  props: {
    source: {
      type: String,
      default: null
    },
    format: {
      type: String,
      default: 'ChordPro'
    }
  },

  emits: ['update:key', 'parse', 'error'],

  data () {
    return {
      columnWidth: 0
    }
  },

  computed: {
    ...mapState(useSongsheetSettingsStore, ['transpose', 'showChords', 'instrument', 'columns']),

    parsed () {
      try {
        return parse(this.source, this.format, { transpose: this.transpose })
      } catch (error) {
        console.error(error)
        this.$emit('error', error)
        return null
      }
    },

    renderer () {
      return this.format === 'OnSong' ? OnSongRenderer : ChordSheetJSRenderer
    }
  },

  watch: {
    columns () {
      this.updateColumnWidth()
    },

    parsed: {
      immediate: true,
      handler (parsed) {
        this.$emit('parse', parsed)
      }
    }
  },

  mounted () {
    this.updateColumnWidth()
  },

  updated () {
    this.updateColumnWidth()
  },

  methods: {
    updateColumnWidth () {
      const output = this.$refs.output
      if (!output) return

      output.classList.add('content-width')
      requestAnimationFrame(() => {
        this.columnWidth = output.offsetWidth + 'px'
        output.classList.remove('content-width')
      })
    },

    formatArray (args) {
      return new Intl.ListFormat().format(arrify(args))
    }
  }
}
</script>

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
