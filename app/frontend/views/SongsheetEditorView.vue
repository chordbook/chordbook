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
        v-model:value="source"
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
        <ion-buttons slot="secondary">
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
          v-if="source"
          :source="source"
          :show-chords="true"
          @parse="onParse"
        />
      </ion-content>
    </ion-modal>
  </ion-page>
</template>

<script>
/* global ace */
/* eslint-disable vue/no-mutating-props */

import ChordSheetJS from 'chordsheetjs'
import detectFormat from '@/lib/detect_format'
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
import { IonPage, IonHeader, IonToolbar, IonBackButton, IonButtons, IonContent, IonFooter, IonLabel, IonButton, IonModal, IonTitle, alertController, loadingController } from '@ionic/vue'
import SongSheet from '@/components/SongSheet.vue'

export default {
  components: { SongSheet, VAceEditor, IonPage, IonHeader, IonToolbar, IonBackButton, IonButtons, IonContent, IonFooter, IonLabel, IonButton, IonModal, IonTitle },

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
      return this.id ? `songsheets/${this.id}.json` : 'songsheets.json'
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
        this.source = (await client.get(`songsheets/${this.id}.json`)).data.source
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
      client({
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
                this.$router.push('/')
                loading.dismiss()
              }
            }
          ]
        })
      return alert.present()
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
