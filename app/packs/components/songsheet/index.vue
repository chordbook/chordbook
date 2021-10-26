<template>
  <!-- Hidden sprite of chord diagrams -->
  <svg hidden xmlns="http://www.w3.org/2000/svg">
    <chord-diagram v-for="chord in chords" :name="chord" :key="chord"/>
  </svg>

  <div class="h-full flex flex-col overflow-hidden">
    <div class="border-b border-t border-gray-300 dark:border-gray-900 bg-gray-100 py-2 text-gray-500 dark:bg-gray-700 shadow-md">
      <div class="container">
        <div class="grid grid-flow-col auto-cols-max divide-x dark:divide-gray-500 items-center">
          <div class="pr-3">
            <div class="flex">
              <div class="toggle" tooltip="Scroll vertically" tooltip-pos="bottom">
                <input id="settings-columns-1" type="radio" name="columns" v-model="columns" value="1">
                <label for="settings-columns-1">
                  <icon-bi:file/>
                </label>
              </div>
              <div class="toggle" tooltip="Scroll horizontally" tooltip-pos="bottom">
                <input id="settings-columns-2" type="radio" name="columns" v-model="columns" value="2">
                <label for="settings-columns-2">
                  <icon-bi:layout-three-columns/>
                </label>
              </div>
            </div>
          </div>

          <div class="px-3">
            <div class="toggle" tooltip="Show Chords" tooltip-pos="bottom">
              <input id="settings-chord-diagram" type="checkbox" v-model="showChords">
              <label for="settings-chord-diagram">
                <icon-app-chord-diagram/>
              </label>
            </div>
          </div>

          <div class="px-3">
            <button class="toggle" @click="toggleTuner" tooltip="Tuner" tooltip-pos="bottom">
              <icon-app-tuning-fork/>
            </button>

            <TransitionRoot appear :show="showTuner"
                enter="duration-400 ease-out" enter-from="opacity-0" enter-to="opacity-100"
                leave="duration-200 ease-in" leave-from="opacity-100" leave-to="opacity-0">
              <Dialog :open="showTuner" @close="toggleTuner" class="fixed inset-0 z-10 overflow-y-auto">
                <div class="flex items-center justify-center min-h-screen">

                  <DialogOverlay class="fixed inset-0 bg-black opacity-50" />

                  <div class="relative max-w-sm mx-auto border bg-white dark:bg-gray-800 dark:text-gray-200 dark:border-black rounded-md overflow-hidden drop-shadow-lg">
                    <tuner></tuner>
                  </div>
                </div>
              </Dialog>
            </TransitionRoot>
          </div>

          <div class="px-3">
            <a :href="edit" class="btn btn-muted btn-small">Edit</a>
          </div>
        </div>
      </div>
    </div>

    <div class="flex-grow overflow-hidden">
      <div class="flex flex-col sm:flex-row h-full">
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
    </div>
  </div>
</template>

<script>
import detectFormat from '../../lib/detect_format'
import ChordLyricsPair from './chord-lyrics-pair.vue'
import Tag from './tag.vue'
  import {
    Dialog,
    DialogOverlay,
  } from "@headlessui/vue";

export default {
  components: {
    'chord-lyrics-pair': ChordLyricsPair,
    'tag': Tag,
    Dialog,
    DialogOverlay
  },

  data() {
    return {
      showTuner: false
    }
  },

  props: {
    source: String,
    edit: String
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

    showChords: {
      get() { return this.$store.state.showChords },
      set(value) { this.$store.commit('update', {showChords: !!value}) }
    },

    columns: {
      get() { return this.$store.state.columns || 1 },
      set(value) { this.$store.commit('update', {columns: value}) }
    }
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

    toggleTuner(showTuner = !this.showTuner) {
      this.showTuner = showTuner
    }
  }
}
</script>
