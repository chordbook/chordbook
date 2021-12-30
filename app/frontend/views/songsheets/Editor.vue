<template>
  <div class="h-full overflow-hidden flex-grow grid md:grid-cols-2 divide-x divide-solid divide-gray-300 dark:divide-gray-700">
    <div class="h-full flex flex-col divide-y divide-solid divide-gray-300 dark:divide-gray-700">
      <div v-if="Object.keys(errors).length">
        <ul class="px-8 py-4 text-red-600">
          <li
            v-for="(messages, attr) in errors"
            :key="attr"
          >
            {{ attr }} {{ messages.join(', ') }}
          </li>
        </ul>
      </div>

      <!-- eslint-disable vue/no-mutating-props -->
      <div class="flex-grow relative">
        <v-ace-editor
          v-model:value="source"
          :theme="theme"
          lang="chordpro"
          style="height: 100%"
          :print-margin="false"
          :options="{fontSize: '0.9rem'}"
          @init="setupEditor"
          @paste="paste"
        />
      </div>

      <div class="px-8 py-3 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 flex gap-2 sm:gap-4 items-center">
        <div class="flex-grow">
          <button
            data-confirm="Are you sure?"
            rel="nofollow"
            class="text-red-600"
            @click.prevent="destroy"
          >
            Delete
          </button>
        </div>

        <div>
          <router-link
            v-if="id"
            :to="{ name: 'songsheet', params: { id }}"
          >
            Cancel
          </router-link>
        </div>
        <div>
          <button
            class="btn btn-primary"
            @click="save"
          >
            Save
          </button>
        </div>
      </div>
    </div>

    <div class="md:block h-full overflow-auto relative">
      <h2 class="text-center uppercase text-gray-400 absolute inset-x-5 top-5">
        Preview
      </h2>

      <song
        vi-if="source"
        :source="source"
        show-chords="last"
        :columns="1"
        @parse="onParse"
      />
    </div>
  </div>
</template>

<script>
/* global ace */
/* eslint-disable vue/no-mutating-props */

import ChordSheetJS from 'chordsheetjs'
import detectFormat from '~/lib/detect_format'
import api from '~/api'
import { VAceEditor } from 'vue3-ace-editor'
import ChordCompleter from '~/ace/chord-completer'
import MetadataCompleter from '~/ace/metadata-completer'
import 'ace-builds/src-noconflict/theme-clouds'
import 'ace-builds/src-noconflict/theme-chaos'
import 'ace-builds/src-noconflict/ext-language_tools'
import '~/ace/mode-chordpro'
import '~/ace/snippets/chordpro'
import { useMediaQuery } from '@vueuse/core'

export default {
  components: { VAceEditor },

  beforeRouteEnter (to, from, next) {
    if (to.params.id) {
      return api.get(`/api/songsheets/${to.params.id}.json`).then(response => {
        next(vm => (vm.source = response.data.source))
      }).catch(() => {
        next({ name: '404', params: [to.path] })
      })
    } else {
      next()
    }
  },

  props: {
    id: {
      type: String,
      required: false,
      default: null
    }
  },

  data () {
    return {
      source: '',
      errors: {},
      themes: { dark: 'chaos', light: 'clouds' },
      isDarkMode: useMediaQuery('(prefers-color-scheme: dark)'),
      song: null
    }
  },

  computed: {
    theme () {
      return this.isDarkMode ? this.themes.dark : this.themes.light
    },

    url () {
      return this.id ? `/api/songsheets/${this.id}.json` : '/api/songsheets.json'
    }
  },

  methods: {
    setupEditor (editor) {
      editor.setOptions({
        enableBasicAutocompletion: true,
        enableSnippets: true,
        enableLiveAutocompletion: true
      })
      editor.renderer.setScrollMargin(20, 20)

      const { snippetCompleter } = ace.require('ace/ext/language_tools')

      editor.completers = [
        new ChordCompleter(),
        new MetadataCompleter(),
        snippetCompleter
      ]

      // Start autocomplete on [ or { characters
      editor.commands.addCommand({
        name: 'chordproStartAutocomplete',
        bindKey: '[|{',
        exec () {
          editor.commands.byName.startAutocomplete.exec(editor)
          return false
        }
      })

      // Expose ace editor for tests
      window.editor = editor
    },

    async save () {
      api({
        url: this.url,
        method: this.id ? 'PATCH' : 'POST',
        data: {
          songsheet: {
            source: this.source,
            metadata: this.song.metadata
          }
        }
      }).then(response => {
        this.$router.push({ name: 'songsheet', params: { id: response.data.id } })
      }).catch(error => {
        if (error.response) {
          this.errors = error.response.data
        } else {
          console.error(error, error.response)
        }
      })
    },

    async destroy (e) {
      if (!confirm(e.target.dataset.confirm)) return

      api({
        url: this.url,
        method: 'DELETE',
        headers: this.headers
      }).then(response => {
        this.$router.push('/')
      })
    },

    paste (e) {
      const format = detectFormat(e.text)

      // No need to convert if it's already in chordpro
      if (!format || format instanceof ChordSheetJS.ChordProParser) return

      // Convert to ChordPro
      // Modifying text property will change text pasted into Ace editor
      e.text = new ChordSheetJS.ChordProFormatter().format(format.parse(e.text))
    },

    onParse (e) {
      this.song = e
    }
  }
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
