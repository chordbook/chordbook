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
            :id="`versions-button-${id}`"
            :disabled="otherVersions.length == 0"
          >
            <ion-icon :icon="icons.list" />
          </ion-button>
        </ion-buttons>

        <ion-buttons slot="end">
          <ion-button id="songsheet-settings-button">
            <ion-icon
              slot="icon-only"
              :icon="icons.transpose"
            />
          </ion-button>
          <ion-button
            :id="`songsheet-context-${songsheet.id}`"
            fill="clear"
            @click.prevent=""
          >
            <ion-icon
              slot="icon-only"
              size="small"
              :ios="icons.iosEllipsis"
              :md="icons.mdEllipsis"
            />
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <song-sheet
      v-if="songsheet.source"
      :source="songsheet.source"
      @update:key="(v) => key = v"
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

    <songsheet-versions-modal
      :trigger="`versions-button-${id}`"
      :versions="otherVersions"
    />
    <songsheet-settings-modal
      trigger="songsheet-settings-button"
      :note="key"
    />
    <ion-popover
      :trigger="`songsheet-context-${songsheet.id}`"
      dismiss-on-select
    >
      <ion-list>
        <ion-item
          button
          detail
          :router-link="{ name: 'songsheet.edit', params: { id: songsheet.id } }"
          :detail-icon="icons.createOutline"
        >
          <ion-label>Edit</ion-label>
        </ion-item>
        <add-to-setlist-item :songsheet="songsheet" />
        <ion-item
          button
          detail
          :detail-icon="icons.tuningFork"
          @click="openTuner"
        >
          Tuner
        </ion-item>
      </ion-list>
    </ion-popover>
  </ion-page>
</template>

<script>
import client from '@/client'
import { IonPage, IonPopover, IonHeader, IonButton, IonIcon, IonToolbar, IonButtons, IonBackButton, modalController, IonLabel, IonList, IonItem } from '@ionic/vue'
import SongSheet from '@/components/SongSheet.vue'
import { apps, arrowUp, arrowDown, list, createOutline } from 'ionicons/icons'
import transpose from '@/icons/transpose.svg?url'
import tuningFork from '@/icons/tuning-fork.svg?url'
import chordDiagram from '@/icons/chord-diagram.svg?url'
import SongsheetVersionsModal from '@/components/SongsheetVersionsModal.vue'
import SongsheetSettingsModal from '@/components/SongsheetSettingsModal.vue'
import TunerView from '@/views/TunerView.vue'
import { Insomnia } from '@awesome-cordova-plugins/insomnia'
import AddToSetlistItem from '@/components/AddToSetlistItem.vue'
import * as icons from '@/icons'

export default {
  components: { SongSheet, IonPage, IonPopover, IonHeader, IonButton, IonIcon, IonToolbar, IonButtons, IonBackButton, IonLabel, IonList, IonItem, AddToSetlistItem, SongsheetVersionsModal, SongsheetSettingsModal },

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
      source: '',
      key: 'C',
      showTuner: false,
      icons: { ...icons, apps, arrowUp, arrowDown, transpose, tuningFork, chordDiagram, list, createOutline }
    }
  },

  computed: {
    otherVersions () {
      return this.versions.filter(v => v.id !== this.songsheet.id)
    }
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
    toggleChords () {
      console.log('WAT?', arguments)
    },

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
