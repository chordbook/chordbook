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
        v-model:value="source"
        @paste="paste"
      />
    </ion-content>
    <ion-footer>
      <ion-toolbar>
        <ion-buttons slot="secondary">
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
import ChordSheetJS from 'chordsheetjs'
import detectFormat from '@/lib/detect_format'
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
      source: '',
      errors: {},
      parsed: null
    }
  },

  computed: {
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

    async save () {
      const { metadata } = this.song.metadata

      client({
        url: this.url,
        method: this.id ? 'PATCH' : 'POST',
        data: {
          songsheet: {
            source: this.source,
            metadata
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
