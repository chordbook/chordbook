<template>
  <ion-content
    v-if="song"
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
          v-for="chord in chords"
          :key="chord + instrument"
          :name="chord"
          :instrument="instrument"
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
          <span class="opacity-40">by</span> {{ formatArray(song.artist) }}
        </div>
        <div>
          <div
            v-if="song.capo"
            class="capo my-4"
          >
            Capo {{ song.capo }}
          </div>
        </div>
      </slot>

      <div
        ref="output"
        class="chord-sheet mt-2"
      >
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
    v-if="showChords"
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

<script>
import { Chord } from 'chordsheetjs'
import detectFormat from '@/lib/detect_format'
import ChordLyricsPair from '@/components/ChordLyricsPair.vue'
import SongSheetComment from '@/components/SongSheetComment.vue'
import ChordDiagram from '@/components/ChordDiagram.vue'
import { IonHeader, IonToolbar, IonTitle, IonContent, IonFooter } from '@ionic/vue'

import { useCssVar } from '@vueuse/core'
import arrify from 'arrify'
import useSongsheetSettingsStore from '@/stores/songsheet-settings'
import { mapState } from 'pinia'

export default {
  components: { ChordLyricsPair, SongSheetComment, ChordDiagram, IonHeader, IonToolbar, IonTitle, IonContent, IonFooter },

  props: {
    source: {
      type: String,
      default: null
    }
  },

  emits: ['update:key', 'parse', 'error'],

  data () {
    return {
      columnWidth: useCssVar('--column-width', this.$el)
    }
  },

  computed: {
    ...mapState(useSongsheetSettingsStore, ['transpose', 'showChords', 'instrument', 'columns']),

    format () {
      return detectFormat(this.source)
    },

    song () {
      try {
        // FIXME: somehow \r is getting added by Ace
        const song = this.format?.parse(this.source.replace(/\r\n/gm, '\n'))

        // Transpose chords
        const chords = {}
        song.lines.forEach(line => {
          line.items.forEach(pair => {
            if (pair.chords) {
              if (!chords[pair.chords]) {
                chords[pair.chords] = Chord.parse(pair.chords)?.transpose(this.transpose).toString()
              }
              pair.transposed = chords[pair.chords]
            }
          })
        })

        this.$emit('parse', song)
        return song
      } catch (error) {
        console.error(error)
        this.$emit('error', error)
        return null
      }
    },

    chords () {
      const chords = new Set()

      if (this.song) {
        this.song.lines.forEach(line => {
          line.items.forEach(pair => {
            if (pair.transposed) chords.add(pair.transposed)
          })
        })
      }

      return chords
    },

    key () {
      // FIXME: use declared key or intelligent key detection
      return this.chords.values().next()
    }
  },

  watch: {
    columns () {
      this.updateColumnWidth()
    },

    key: {
      immediate: true,
      handler ({ value }) {
        if (value) this.$emit('update:key', value)
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
    componentFor (item) {
      return [ChordLyricsPair, SongSheetComment].find(c => c.for(item))
    },

    updateColumnWidth () {
      const output = this.$refs.output
      if (!output) return

      output.classList.add('content-width')
      requestAnimationFrame(() => {
        this.columnWidth = output.offsetWidth + 'px'
        output.classList.remove('content-width')
      })
    },

    toggleTuner () {
      this.showTuner = !this.showTuner
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
  column-width: var(--column-width);
  min-width: var(--column-width);
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
  @apply text-blue-800 dark:text-blue-200 pr-1 font-medium text-sm;
}

.chorus {
  border-left: 3px solid;
  @apply border-neutral-200 pl-4;
}

.chorus::before {
  content: "Chorus:";
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
