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

      <songsheet-editor
        v-model:value="songsheet.source"
        :format="songsheet.format"
        @paste="paste"
      />
    </ion-content>
    <ion-footer>
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
            v-if="id"
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
          :format="songsheet.format"
          @parse="(value) => parsed = value"
        />
      </ion-content>
    </ion-modal>
  </ion-page>
</template>

<script>
import ChordSheetJS from 'chordsheetjs'
import formats, { guess as guessFormat } from '@/formats'
import client from '@/client'
import { alertController, loadingController } from '@ionic/vue'
import SongSheet from '@/components/SongSheet.vue'
import SongsheetEditor from '@/components/SongsheetEditor.vue'

export default {
  components: { SongSheet, SongsheetEditor },

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
      formats: Object.keys(formats)
    }
  },

  computed: {
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

    async save () {
      const { source, format } = this.songsheet
      const { metadata } = this.parsed

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
      // Only attempt to convert if target is ChordPro
      if (this.songsheet.format !== 'ChordPro') return

      const format = guessFormat(e.text)

      // No need to convert if it's already in chordpro
      if (!format || format.name === 'ChordPro') return

      // Modifying text property will change text pasted into Ace editor
      const { song } = format.parse(e.text)
      e.text = new ChordSheetJS.ChordProFormatter().format(song)
    },

    dismissPreview () {
      this.$refs.preview.$el.dismiss()
    }
  }
}
</script>
