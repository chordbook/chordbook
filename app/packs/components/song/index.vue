<template>
  <div v-if="source" class="flex flex-col sm:flex-row h-full">
    <!-- Hidden sprite of chord diagrams -->
    <svg hidden xmlns="http://www.w3.org/2000/svg">
      <chord-diagram v-for="chord in chords" :name="chord" :key="chord"/>
    </svg>

    <div v-if="showChords" :class="(showChords == 'last' ? 'order-last border-t sm:border-l sm:border-t-0' : 'border-b sm:border-r sm:border-b-0') + ' flex flex-row sm:flex-col p-4 overflow-auto border-gray-200 dark:border-gray-700'">
      <div v-for="name in chords" class="text-center text-sm" :key="name">
        <div class="chord">{{ name }}</div>
        <svg class="chord-diagram inline-block" xmlns="http://www.w3.org/2000/svg" role="image" :title="name">
          <use :xlink:href="`#chord-${name}`" viewBox="0 0 50 65"></use>
        </svg>
      </div>
    </div>

    <div class="overflow-auto flex-grow h-full">
      <div :class="'py-4 md:py-8 lg:py-12 ' + (columns == 1 ? 'single-column' : 'horizontal-columns')">
        <div class="column-span-all">
          <h1 v-if="song.title">{{ song.title }}</h1>
          <h2 v-if="song.subtitle">{{ song.subtitle }}</h2>
          <h2 v-if="song.artist">by {{ song.artist }}</h2>
          <div v-if="song.capo">Capo {{ song.capo }}</div>
        </div>

        <div ref="output" class="chord-sheet">
          <div v-for="paragraph in song.paragraphs" :class="paragraph.type + ' paragraph'">
            <template v-for="line in paragraph.lines">
              <div v-if="line.hasRenderableItems()" class="row">
                <template v-for="item in line.items">
                  <component v-if="item.isRenderable()" :is="componentFor(item)" :item="item" />
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
import detectFormat from '../../lib/detect_format'
import ChordLyricsPair from './chord-lyrics-pair.vue'
import Tag from './tag.vue'

export default {
  components: { ChordLyricsPair, Tag },

  props: {
    source: String,

    showChords: {
      type: [Boolean, String],
      default: false
    },

    columns: {
      type: Number,
      default: 1
    }
  },

  mounted() {
    this.updateColumnWidth();
  },

  updated() {
    this.updateColumnWidth()
  },

  computed: {
    format() {
      return detectFormat(this.source)
    },

    song() {
      // FIXME: somehow \r is getting added by Ace
      return this.format.parse(this.source.replace(/\r\n/gm, "\n"))
    },

    chords() {
      const chords = new Set()
      this.song.lines.forEach(line => {
        line.items.forEach(pair => {
          if(pair.chords) chords.add(pair.chords)
        })
      })
      return chords
    },
  },

  methods: {
    componentFor(item) {
      return [ChordLyricsPair, Tag].find(c => c.for(item))
    },

    updateColumnWidth() {
      const output = this.$refs.output

      if(output) {
        output.classList.add('content-width')
        document.documentElement.style.setProperty('--column-width', output.offsetWidth + 'px')
        output.classList.remove('content-width')
      }
    },

    toggleTuner() {
      this.showTuner = !this.showTuner
    }
  },

  watch: {
    columns() {
      this.updateColumnWidth()
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

  .column-span-all {
    column-span: all;
  }
}

.single-column {
  @apply container;

  .row {
    flex-wrap: wrap;
  }
}

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

.comment {
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

*:not(.tab) .chord {
  @apply text-blue-900 dark:text-blue-200 pr-1;
}

.chorus {
  border-left: 4px solid #999;
  padding-left: 1em;

  &::before {
    content: "Chorus:";
    @extend .comment;
  }
}

.verse::before {
  counter-increment: verse;
  content: "Verse " counter(verse) ":";
  @extend .comment;
}

.chord:after, .lyrics:after {
  content: '\200b';
}

.chord-diagram {
  width: 50px;
  height: 65px;
}
</style>
