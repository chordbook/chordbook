<script>
/* global ace */
import { VAceEditor } from 'vue3-ace-editor'
import ChordCompleter from '@/ace/chord-completer'
import MetadataCompleter from '@/ace/metadata-completer'
import 'ace-builds/src-noconflict/theme-clouds'
import 'ace-builds/src-noconflict/theme-chaos'
import 'ace-builds/src-noconflict/ext-language_tools'
import '@/ace/mode-chordpro'
import '@/ace/snippets/chordpro'
import { useMediaQuery } from '@vueuse/core'

export default {
  components: { VAceEditor },

  props: {
    format: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      isDarkMode: useMediaQuery('(prefers-color-scheme: dark)')
    }
  },

  computed: {
    theme () {
      return this.isDarkMode ? 'chaos' : 'clouds'
    },

    lang () {
      return this.format === 'ChordPro' ? 'chordpro' : 'text'
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
    }
  }
}
</script>

<template>
  <v-ace-editor
    :theme="theme"
    :print-margin="false"
    :options="{fontSize: '0.9rem'}"
    :lang="lang"
    style="height: 100%"
    @init="setupEditor"
  />
</template>

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
