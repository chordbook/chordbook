<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/songsheets"
          />
          <ion-button
            id="versions-button"
            :disabled="versions.length <= 1"
          >
            <ion-icon :icon="icons.list" />
          </ion-button>
        </ion-buttons>

        <ion-buttons slot="end">
          <ion-button id="transpose-button">
            <ion-icon
              slot="icon-only"
              :icon="icons.transpose"
            />
          </ion-button>
          <ion-button @click="showChords = !showChords">
            <ion-icon
              slot="icon-only"
              :icon="icons.chordDiagram"
            />
          </ion-button>
          <ion-button @click="openTuner">
            <ion-icon
              slot="icon-only"
              :icon="icons.tuningFork"
            />
          </ion-button>
          <ion-button :router-link="{ name: 'songsheet.edit', params: { id } }">
            <ion-label>Edit</ion-label>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <song-sheet
      v-if="songsheet.source"
      :source="songsheet.source"
      :show-chords="showChords"
      :transpose="transpose"
      @update:key="key = $event.value"
    >
      <template #footer>
        <div class="ion-padding text-sm opacity-50 mb-8 flex gap-4">
          <div>Updated {{ formatDate(songsheet.updated_at) }}</div>
          <div v-if="songsheet.imported_from">
            Imported from
            <a
              target="_blank"
              :href="songsheet.imported_from"
              class="text-inherit no-underline"
            >
              {{ hostname(songsheet.imported_from) }}
            </a>
          </div>
        </div>
      </template>
    </song-sheet>

    <ion-popover trigger="transpose-button">
      <ion-content>
        <transpose-control
          :note="key"
          @update="updateTranspose"
        />
      </ion-content>
    </ion-popover>

    <ion-popover
      trigger="versions-button"
      dismiss-on-select
    >
      <ion-list>
        <ion-list-header>Alternate Versions</ion-list-header>
        <template v-for="version in versions">
          <songsheet-item
            v-if="songsheet.id !== version.id"
            :key="version.id"
            :songsheet="version"
          />
        </template>
      </ion-list>
    </ion-popover>
  </ion-page>
</template>

<script>
import client from '@/client'
import { IonPage, IonContent, IonPopover, IonHeader, IonButton, IonIcon, IonToolbar, IonButtons, IonBackButton, modalController, IonLabel, IonList, IonListHeader } from '@ionic/vue'
import SongSheet from '@/components/SongSheet.vue'
import { apps, arrowUp, arrowDown, list } from 'ionicons/icons'
import transpose from '@/icons/transpose.svg?url'
import tuningFork from '@/icons/tuning-fork.svg?url'
import chordDiagram from '@/icons/chord-diagram.svg?url'
import TransposeControl from '@/components/TransposeControl.vue'
import TunerView from '@/views/TunerView.vue'
import { Insomnia } from '@awesome-cordova-plugins/insomnia'
import SongsheetItem from '@/components/SongsheetItem.vue'

export default {
  components: { SongSheet, TransposeControl, IonPage, IonContent, IonPopover, IonHeader, IonButton, IonIcon, IonToolbar, IonButtons, IonBackButton, IonLabel, SongsheetItem, IonList, IonListHeader },

  props: {
    id: {
      type: String,
      required: true
    },

    type: {
      type: String,
      default () { return 'songsheet' }
    }
  },

  data () {
    return {
      songsheet: {},
      versions: [],
      showTuner: false,
      source: '',
      key: 'C',
      transpose: 0,
      icons: { apps, arrowUp, arrowDown, transpose, tuningFork, chordDiagram, list }
    }
  },

  computed: {
    showChords: {
      get () { return this.$store.state.showChords },
      set (value) { this.$store.commit('update', { showChords: !!value }) }
    }

    //   columns: {
    //     get () { return this.$store.state.columns || 1 },
    //     set (value) { this.$store.commit('update', { columns: value }) }
    //   },
  },

  ionViewWillEnter () {
    this.fetchData()
  },

  ionViewDidEnter () {
    return Insomnia.keepAwake()
  },

  ionViewWillLeave () {
    return Insomnia.allowSleepAgain()
  },

  methods: {
    async fetchData () {
      if (this.type === 'songsheet') {
        await this.fetchSongsheet(this.id)
        if (this.songsheet.track) {
          await this.fetchVersions(this.songsheet.track.id)
        }
      } else {
        await this.fetchVersions(this.id)
        if (this.versions.length > 0) {
          this.fetchSongsheet(this.versions[0].id)
        } else {
          this.$router.push({ name: 'songsheet.new', params: { track: this.id }, replace: true })
        }
      }
    },

    async fetchSongsheet (id) {
      this.songsheet = (await client.get(`/api/songsheets/${id}.json`)).data
    },

    async fetchVersions (id) {
      this.versions = (await client.get(`/api/tracks/${id}/songsheets.json`)).data
    },

    async openTuner () {
      const modal = await modalController
        .create({
          component: TunerView,
          initialBreakpoint: 0.5,
          breakpoints: [0, 0.5]
        })
      return modal.present()
    },

    updateTranspose (value) {
      this.transpose = value
    },

    formatDate (input) {
      if (!input) return ''
      const date = new Date(input)
      return new Intl.DateTimeFormat(navigator.language).format(date)
    },

    hostname (url) {
      return new URL(url).hostname
    }
  }
}
</script>
