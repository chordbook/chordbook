<template>
  <div class="h-full flex flex-col">
    <div class="border-b border-t border-gray-300 dark:border-gray-900 bg-gray-100 py-2 text-gray-500 dark:bg-gray-700 shadow-md">
      <form class="2xl-container mx-auto md:px-8 lg:px-12" name="settings" data-controller="localstorage" data-action="input->localstorage#save">
        <div class="grid grid-flow-col auto-cols-max divide-x dark:divide-gray-500 items-center">
          <div class="pr-3">
            <div class="flex" data-controller="toggle" data-target="#output">
              <div class="toggle">
                <input id="settings-columns-1" type="radio" name="columns" value="1" data-toggle-target="input" data-action="toggle#classes" data-toggle-classes="container mx-auto single-column">
                <label for="settings-columns-1">
                  1
                </label>
              </div>
              <div class="toggle">
                <input id="settings-columns-2" type="radio" name="columns" value="2" checked data-toggle-target="input" data-action="toggle#classes" data-toggle-classes="horizontal-columns overflow-x-auto h-full gap-x-2">
                <label for="settings-columns-2">
                  2
                </label>
              </div>
            </div>
          </div>

          <div class="px-3">
            <div class="toggle" data-controller="toggle" data-target="#chords">
              <input id="settings-chord-diagram" type="checkbox" name="chord-diagram" data-toggle-target="input" data-action="toggle#visibility">
              <label for="settings-chord-diagram">
                chords
              </label>
            </div>
          </div>

          <div class="px-3">
            <wakelock></wakelock>
          </div>

          <div class="px-3">
            <a href="" class="btn btn-muted btn-small">Edit</a>
          </div>
        </div>
      </form>
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
