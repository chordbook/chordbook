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
        <v-ace-editor v-model:value="source" theme="chrome" lang="chordpro" style="height: 100%" :printMargin="false"></v-ace-editor>
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
          <button :disabled="!source" @click="save" class="btn btn-primary">Save</button>
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
import 'ace-builds/src-noconflict/mode-text'
import '~/ace/mode-chordpro'
import 'ace-builds/src-noconflict/theme-chrome'

export default {
  components: { VAceEditor },

  data() {
    return {
      source: '',
      errors: {}
    }
  },

  props: {
    url: String,
    song: Object
  },

  mounted() {
    // FIXME: for some reason `this.song.source` is not reactive, so this is a hack
    this.source = this.song.source
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
    async save() {
      Object.assign(this.song, {
        metadata: this.parsedSong.metadata,
        source: this.source
      })

      axios({
        url: this.url,
        method: this.song.id ? 'PATCH' : 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        data: {songsheet: this.song},
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

#editor-view {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
}
</style>
