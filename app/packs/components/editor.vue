<template>
  <div class="h-full overflow-hidden flex-grow grid md:grid-cols-2 divide-x divide-solid divide-gray-300 dark:divide-gray-700">
    <div class="h-full flex flex-col divide-y divide-solid divide-gray-300 dark:divide-gray-700">
      <div v-if="Object.keys(errors).length">
        <ul class="px-8 py-4 text-red-600">
          <li v-for="(messages, attr) in errors" :key="attr">
            {{ attr }} {{ messages.join(', ')}}
          </li>
        </ul>
      </div>

      <div class="flex-grow relative">
        <v-ace-editor @init="setupEditor" v-model:value="source" :theme="theme" lang="chordpro" style="height: 100%" :printMargin="false" :options="{fontSize: '0.9rem'}"></v-ace-editor>
      </div>

      <div class="px-8 py-3 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 flex gap-2 sm:gap-4 items-center">
        <div class="flex-grow">
          <a :href="url" data-method="delete" data-confirm="Are you sure?" rel="nofollow" class="text-red-600">
            Delete
          </a>
        </div>

        <div>
          <a :href="url">Cancel</a>
        </div>
        <div>
          <button @click="save" class="btn btn-primary">Save</button>
        </div>
      </div>
    </div>

    <div class="md:block h-full overflow-auto relative">
      <h2 class="text-center uppercase text-gray-400 absolute inset-x-5 top-5">Preview</h2>

      <song :source="source" showChords="last" :columns="1"></song>
    </div>
  </div>
</template>

<script>
import Turbolinks from 'turbolinks'
import ChordSheetJS from 'chordsheetjs'
import detectFormat from '../lib/detect_format'
import axios from 'axios'
import { VAceEditor } from 'vue3-ace-editor'
import ChordCompleter from '~/ace/chord-completer'
import 'ace-builds/src-noconflict/theme-clouds'
import 'ace-builds/src-noconflict/theme-chaos'
import 'ace-builds/src-noconflict/ext-language_tools'
import '~/ace/mode-chordpro'
import '~/ace/snippets/chordpro'

const darkModeDetector = window.matchMedia('(prefers-color-scheme: dark)')

export default {
  components: { VAceEditor },

  data() {
    return {
      errors: {},
      themes: {dark: 'chaos', light: 'clouds'},
      theme: 'clouds',
    }
  },

  props: {
    url: String,
    source: String,
    id: String,
  },

  mounted() {
    this.toggleTheme = this.toggleTheme.bind(this)
    darkModeDetector.addEventListener('change', this.toggleTheme)
    this.toggleTheme()
  },

  unmounted() {
    darkModeDetector.removeEventListener('change', this.toggleTheme)
  },

  computed: {
    format() {
      return detectFormat(this.source)
    },

    parsedSong() {
      return this.format.parse(this.source)
    },
  },

  methods: {
    toggleTheme() {
      this.theme = darkModeDetector.matches ? this.themes.dark : this.themes.light
    },

    setupEditor(editor) {
      editor.setOptions({
        enableBasicAutocompletion: true,
        enableSnippets: true,
        enableLiveAutocompletion: true,
      })
      editor.renderer.setScrollMargin(20, 20)

      const { snippetCompleter } = ace.require('ace/ext/language_tools')
      editor.completers = [new ChordCompleter(), snippetCompleter]
    },

    async save() {
      axios({
        url: this.url,
        method: this.id ? 'PATCH' : 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        data: {
          songsheet: {
            source: this.source,
            metadata: this.parsedSong.metadata
          }
        },
      }).then(response => {
        Turbolinks.visit(response.headers.location || url)
      }).catch(error => {
        if(error.response) {
          this.errors = error.response.data
        } else {
          console.error(error, error.response)
        }
      })
    },

    paste(e) {
      const paste = (e.clipboardData || window.clipboardData).getData('text')
      const format = detectFormat(paste)

      // No need to convert if it's already in chordpro
      if (!format || format instanceof ChordSheetJS.ChordProParser) return

      // Convert to ChordPro
      e.preventDefault()
      this.source = new ChordSheetJS.ChordProFormatter().format(format.parse(paste))
    }
  },
}
</script>

<style>
.ace_scroller { padding-left: 0.5em }

/* FIXME: Move to a proper ace theme */
.ace_editor { background: transparent; }
.ace_editor .ace_gutter { @apply bg-gray-50 dark:bg-gray-900 }
.ace_editor .ace_string { @apply text-black dark:text-white font-bold }
.ace_editor .ace_meta { @apply text-red-400 }
.ace_editor .ace_meta.ace_tag,
.ace_editor .ace_constant { @apply text-gray-400 dark:text-gray-500 }
.ace_editor .ace_keyword { @apply text-blue-700 dark:text-blue-400 }
</style>
