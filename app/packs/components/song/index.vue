<template>
  <div class="flex flex-col sm:flex-row h-full">
    <!-- Hidden sprite of chord diagrams -->
    <svg hidden xmlns="http://www.w3.org/2000/svg">
      <chord-diagram v-for="chord in chords" :name="chord" :key="chord"/>
    </svg>

    <div v-if="showChords" class="flex flex-row sm:flex-col border-b sm:border-r sm:border-b-0 border-gray-200 dark:border-gray-700 p-4 overflow-auto">
      <div v-for="name in chords" class="text-center text-sm" :key="name">
        <div class="chord">{{ name }}</div>
        <svg class="chord-diagram" xmlns="http://www.w3.org/2000/svg" role="image" :title="name">
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
      type: Boolean,
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
      return this.format.parse(this.source)
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
      output.classList.add('content-width')
      document.documentElement.style.setProperty('--column-width', output.offsetWidth + 'px')
      output.classList.remove('content-width')
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
