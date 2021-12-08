<template>
  <div
    v-if="source"
    class="flex flex-col sm:flex-row h-full"
  >
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

    <div
      v-if="showChords"
      :class="(showChords == 'last' ? 'order-last border-t sm:border-l sm:border-t-0' : 'border-b sm:border-r sm:border-b-0') + ' flex flex-row sm:flex-col p-4 overflow-auto border-gray-200 dark:border-gray-700'"
    >
      <div class="text-xs uppercase mb-4 text-gray-400 relative">
        <Listbox v-model="instrument">
          <ListboxButton class="uppercase btn btn-small btn-muted">
            {{ instrument }}
            <icon-bi:chevron-down class="icon-xs ml-1" />
          </ListboxButton>
          <ListboxOptions class="absolute btn btn-small btn-muted bg-white dark:bg-black block p-0 overflow-hidden w-full mt-2">
            <ListboxOption
              v-for="i in instruments"
              v-slot="{ active, selected }"
              :key="i"
              as="template"
              :value="i"
            >
              <li
                :class="['px-3 py-2 cursor-pointer', {
                  'bg-white dark:bg-gray-900': !(active || selected),
                  'bg-green-400 text-white dark:bg-gray-600': selected,
                  'bg-green-100 dark:bg-gray-700': active,
                }]"
              >
                {{ i }}
              </li>
            </ListboxOption>
          </ListboxOptions>
        </Listbox>
      </div>

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

    <div class="overflow-auto flex-grow h-full">
      <div :class="'py-4 md:py-8 lg:py-12 ' + (columns == 1 ? 'single-column' : 'horizontal-columns')">
        <div class="column-span-all">
          <h1 v-if="song.title">
            {{ song.title }}
          </h1>
          <h2 v-if="song.subtitle">
            {{ song.subtitle }}
          </h2>
          <h2 v-if="song.artist">
            by {{ song.artist }}
          </h2>
          <div v-if="song.capo">
            Capo {{ song.capo }}
          </div>
        </div>

        <div
          ref="output"
          class="chord-sheet"
        >
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
    </div>
  </div>
</template>

<script>
import { Chord } from 'chordsheetjs'
import detectFormat from '../lib/detect_format'
import ChordLyricsPair from './song/chord-lyrics-pair.vue'
import Tag from './song/tag.vue'
import {
  Listbox,
  ListboxButton,
  ListboxOptions,
  ListboxOption
} from '@headlessui/vue'
import { useCssVar } from '@vueuse/core'

export default {
  components: { ChordLyricsPair, Tag, Listbox, ListboxButton, ListboxOptions, ListboxOption },

  props: {
    source: {
      type: String,
      default: null
    },

    showChords: {
      type: [Boolean, String],
      default: false
    },

    columns: {
      type: Number,
      default: 1
    },

    transpose: {
      type: Number,
      default: 0
    }
  },

  emits: ['update:key'],

  data () {
    return {
      columnWidth: useCssVar('--column-width', this.$el),
      instruments: ['guitar', 'ukulele']
    }
  },

  computed: {
    format () {
      return detectFormat(this.source)
    },

    song () {
      // FIXME: somehow \r is getting added by Ace
      const song = this.format.parse(this.source.replace(/\r\n/gm, '\n'))

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

      return song
    },

    chords () {
      const chords = new Set()
      this.song.lines.forEach(line => {
        line.items.forEach(pair => {
          if (pair.transposed) chords.add(pair.transposed)
        })
      })
      return chords
    },

    key () {
      // FIXME: use declared key or intelligent key detection
      return this.chords.values().next()
    },

    instrument: {
      get () { return this.$store.state.instrument || 'guitar' },
      set (value) { this.$store.commit('update', { instrument: value }) }
    }
  },

  watch: {
    columns () {
      this.updateColumnWidth()
    }
  },

  mounted () {
    this.updateColumnWidth()
    this.$emit('update:key', this.key)
  },

  updated () {
    this.updateColumnWidth()
  },

  methods: {
    componentFor (item) {
      return [ChordLyricsPair, Tag].find(c => c.for(item))
    },

    updateColumnWidth () {
      const output = this.$refs.output

      if (output) {
        output.classList.add('content-width')
        this.columnWidth = output.offsetWidth + 'px'
        // document.documentElement.style.setProperty('--column-width', )
        output.classList.remove('content-width')
      }
    },

    toggleTuner () {
      this.showTuner = !this.showTuner
    }
  }
}
</script>

<style>
.horizontal-columns {
  @apply max-w-none w-auto mx-0 overflow-x-auto h-full gap-x-2 px-4 md:px-8 lg:px-12;
  column-count: auto;
  column-width: var(--column-width);
  column-fill: auto;
}
.horizontal-columns .column-span-all { column-span: all; }

.single-column { @apply container; }
.single-column .row { flex-wrap: wrap; }

.content-width {
  overflow: auto !important;
  max-width: max-content !important;
  min-width: max-content !important;
  width: max-content !important;
  display: inline-block !important;
  flex-wrap: nowrap !important;
}

.chord-sheet {
  counter-reset: verse;
}

.paragraph {
  break-inside: avoid;
}

.paragraph + .paragraph {
  @apply mt-6;
}

.row {
  display: flex;
  flex-wrap: nowrap;
  position: relative;
  break-inside: avoid;
}

.column {
  display: flex;
  flex-direction: column;
}

.comment, .chorus:before, .verse::before {
  font-weight: bold;
  font-style: italic;
  break-after: avoid;
}

.chord, .lyrics {
  white-space: pre;
}

.tab {
  @apply font-mono text-xs;
}

.lyrics {}

.capo {
  @apply text-sm;
}

.chord-sheet *:not(.tab) .chord {
  @apply text-blue-900 dark:text-blue-200 pr-1;
}

.chorus {
  border-left: 4px solid #999;
  padding-left: 1em;
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
