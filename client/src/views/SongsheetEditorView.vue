<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="secondary">
          <ion-back-button
            text="Cancel"
            :default-href="id ? `/songsheets/${id}` : '/songsheets'"
          />
        </ion-buttons>

        <ion-buttons slot="primary">
          <ion-button id="trigger-preview">
            <ion-label>Preview</ion-label>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
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

      <v-ace-editor
        v-model:value="songsheet.source"
        :theme="theme"
        lang="chordpro"
        style="height: 100%"
        :print-margin="false"
        :options="{fontSize: '0.9rem'}"
        @init="setupEditor"
        @paste="paste"
      />
    </ion-content>
    <ion-footer v-if="id">
      <ion-toolbar>
        <ion-buttons slot="end">
          <ion-select
            v-model="songsheet.format"
            placeholder="Format"
          >
            <ion-select-option
              v-for="formatName in formats"
              :key="formatName"
            >
              {{ formatName }}
            </ion-select-option>
          </ion-select>
        </ion-buttons>

        <ion-buttons slot="start">
          <ion-button
            fill="clear"
            color="danger"
            @click="destroy"
          >
            Delete
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-footer>

    <ion-modal
      ref="preview"
      trigger="trigger-preview"
    >
      <ion-header translucent>
        <ion-toolbar>
          <ion-title>Preview</ion-title>

          <ion-buttons slot="secondary">
            <ion-button @click="dismissPreview">
              <ion-label>Edit</ion-label>
            </ion-button>
          </ion-buttons>

          <ion-buttons slot="primary">
            <ion-button @click="save">
              <ion-label>Save</ion-label>
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content fullscreen>
        <song-sheet
          v-if="songsheet.source"
          :source="songsheet.source"
          :show-chords="true"
          @parse="onParse"
        />
      </ion-content>
    </ion-modal>
  </ion-page>
</template>

<script>
/* global ace */
import ChordSheetJS from 'chordsheetjs'
import formats, { guess as guessFormat } from '@/formats'
import client from '@/client'
import { VAceEditor } from 'vue3-ace-editor'
import ChordCompleter from '@/ace/chord-completer'
import MetadataCompleter from '@/ace/metadata-completer'
import 'ace-builds/src-noconflict/theme-clouds'
import 'ace-builds/src-noconflict/theme-chaos'
import 'ace-builds/src-noconflict/ext-language_tools'
import '@/ace/mode-chordpro'
import '@/ace/snippets/chordpro'
import { useMediaQuery } from '@vueuse/core'
import { alertController, loadingController } from '@ionic/vue'
import SongSheet from '@/components/SongSheet.vue'

export default {
  components: { SongSheet, VAceEditor },

  props: {
    id: {
      type: String,
      required: false,
      default: null
    }
  },

  data () {
    return {
      songsheet: { format: 'ChordPro', source: '' },
      errors: {},
      themes: { dark: 'chaos', light: 'clouds' },
      isDarkMode: useMediaQuery('(prefers-color-scheme: dark)'),
      song: null,
      formats: Object.keys(formats)
    }
  },

  computed: {
    theme () {
      return this.isDarkMode ? this.themes.dark : this.themes.light
    },

    url () {
      return this.songsheet.id ? `songsheets/${this.songsheet.id}.json` : 'songsheets.json'
    }
  },

  watch: {
    $route: 'fetchData'
  },

  created () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      if (this.id) {
        this.songsheet = (await client.get(`songsheets/${this.id}.json`)).data
      }
    },

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
      const { source, format } = this.songsheet
      const metadata = this.song.metadata

      client({
        url: this.url,
        method: this.songsheet.id ? 'PATCH' : 'POST',
        data: { songsheet: { source, format, metadata } }
      }).then(response => {
        this.$router.push({ name: 'songsheet', params: { id: response.data.id } })
        this.dismissPreview()
      }).catch(error => {
        if (error.response) {
          this.errors = error.response.data
        } else {
          console.error(error, error.response)
        }
        this.dismissPreview()
      })
    },

    async destroy (e) {
      const alert = await alertController
        .create({
          header: 'Are you sure?',
          message: 'Do you want to delete this song?',
          buttons: [
            {
              text: 'Cancel',
              role: 'cancel'
            },
            {
              text: 'Delete',
              role: 'destructive',
              handler: async () => {
                const loading = await loadingController.create({
                  message: 'Deleting…',
                  duration: 5000,
                  translucent: true
                })
                await loading.present()
                await client({ url: this.url, method: 'DELETE', headers: this.headers })
                this.$router.push({ name: 'songsheets' })
                loading.dismiss()
              }
            }
          ]
        })
      return alert.present()
    },

    paste (e) {
      const format = guessFormat(e.text)

      // No need to convert if it's already in chordpro
      if (!format || format.name === 'ChordPro') return

      // Convert to ChordPro
      // Modifying text property will change text pasted into Ace editor
      e.text = new ChordSheetJS.ChordProFormatter().format(format.parser.parse(e.text))
    },

    onParse (e) {
      this.song = e
    },

    dismissPreview () {
      this.$refs.preview.$el.dismiss()
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
