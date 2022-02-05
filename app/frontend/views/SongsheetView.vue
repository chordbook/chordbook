<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/songsheets"
          />
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
  </ion-page>
</template>

<script>
import client from '@/client'
import { IonPage, IonContent, IonPopover, IonHeader, IonButton, IonIcon, IonToolbar, IonButtons, IonBackButton, modalController, IonLabel } from '@ionic/vue'
import SongSheet from '@/components/SongSheet.vue'
import { apps, arrowUp, arrowDown } from 'ionicons/icons'
import transpose from '@/icons/transpose.svg?url'
import tuningFork from '@/icons/tuning-fork.svg?url'
import chordDiagram from '@/icons/chord-diagram.svg?url'
import TransposeControl from '@/components/TransposeControl.vue'
import TunerView from '@/views/TunerView.vue'
import { Insomnia } from '@awesome-cordova-plugins/insomnia'

export default {
  components: { SongSheet, TransposeControl, IonPage, IonContent, IonPopover, IonHeader, IonButton, IonIcon, IonToolbar, IonButtons, IonBackButton, IonLabel },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      songsheet: {},
      showTuner: false,
      source: '',
      key: 'C',
      transpose: 0,
      icons: { apps, arrowUp, arrowDown, transpose, tuningFork, chordDiagram }
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
      this.songsheet = (await client.get(`/api/songsheets/${this.id}.json`)).data
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
