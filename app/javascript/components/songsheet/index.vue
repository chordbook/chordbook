<template>
  <div class="h-full flex flex-col">
    <div class="border-b border-t border-gray-300 dark:border-gray-900 bg-gray-100 py-2 text-gray-500 dark:bg-gray-700 shadow-md">
      <!--<toolbar></toolbar>-->
    </div>

    <svg hidden xmlns="http://www.w3.org/2000/svg">
      <chord-diagram v-for="chord in chords" :name="chord"/>
    </svg>

    <div class="flex-grow overflow-auto relative h-full">
      <div class="z-0 p-4 md:p-8 lg:p-12">
        <h1 v-if="song.title">{{ song.title }}</h1>
        <h2 v-if="song.subtitle">{{ song.subtitle }}</h2>
        <h2 v-if="song.artist">by {{ song.artist }}</h2>
        <div v-if="song.capo">Capo {{ song.capo }}</div>

        <div class="chord-sheet">
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
  components: {
    'chord-lyrics-pair': ChordLyricsPair,
    'tag': Tag,
  },

  props: {
    source: String
  },

  // TODO: set colum with after rendering
  // updated: function() {
  //   this.$nextTick(() => {
  //     this.outputTarget.style.width = 'max-content'
  //     document.documentElement.style.setProperty('--column-width', this.outputTarget.offsetWidth + 'px')
  //     this.outputTarget.style.removeProperty('width')
  //   })
  // }

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
    }
  }
}

</script>
