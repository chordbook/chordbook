<template>
  <ion-page>
    <ion-header :translucent="true">
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
              src="/icons/transpose.svg"
            />
          </ion-button>
          <ion-button @click="showChords = !showChords">
            <ion-icon
              slot="icon-only"
              src="/icons/chord-diagram.svg"
            />
          </ion-button>
          <ion-button @click="openTuner">
            <ion-icon
              slot="icon-only"
              src="/icons/tuning-fork.svg"
            />
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
    />

    <ion-popover trigger="transpose-button">
      <ion-content>
        <transpose-control
          :note="key"
          @update="updateTranspose"
        />
      </ion-content>
    </ion-popover>
    <!--
    <div class="dark:border-gray-900 bg-gray-100 py-3 text-gray-500 dark:bg-slate-900 shadow-md">
      <div class="max-w-8xl mx-auto px-4 md:px-6">
        <div class="grid grid-flow-col auto-cols-max divide-x dark:divide-gray-500 items-center">

          <div class="px-3">
            <div class="flex items-center">

            </div>
          </div>

          <div class="px-3">
            <div
              class="toggle"
              tooltip="Show Chords"
              tooltip-pos="bottom"
            >
              <input
                id="settings-chord-diagram"
                v-model="showChords"
                type="checkbox"
              >
              <label for="settings-chord-diagram">
                <icon-app-chord-diagram />
              </label>
            </div>
          </div>

          <div class="px-3">
            <button
              class="toggle"
              tooltip="Tuner"
              tooltip-pos="bottom"
              @click="toggleTuner"
            >
              <icon-app-tuning-fork />
            </button>

            <TransitionRoot
              :show="showTuner"
              enter="transition-opacity duration-75"
              enter-from="opacity-0"
              enter-to="opacity-100"
              leave="transition-opacity duration-150"
              leave-from="opacity-100"
              leave-to="opacity-0"
            >
              <Dialog
                class="fixed inset-0 z-10 overflow-y-auto"
                @close="toggleTuner"
              >
                <div class="flex items-center justify-center min-h-screen">
                  <DialogOverlay class="fixed inset-0 bg-black opacity-50" />

                  <div class="relative max-w-sm mx-auto border bg-white dark:bg-gray-800 dark:text-gray-200 dark:border-black rounded-md overflow-hidden drop-shadow-lg">
                    <tuner />
                  </div>
                </div>
              </Dialog>
            </TransitionRoot>
          </div>

          <div class="px-3">
            <router-link
              :to="{ name: 'songsheet.edit', params: { id: $route.params.id } }"
              class="btn btn-muted btn-small"
            >
              Edit
            </router-link>
          </div>
        </div>
      </div>
    </div>

    -->
  </ion-page>
</template>

<script>
import client from '@/client'
import { IonPage, IonContent, IonPopover, IonHeader, IonFooter, IonButton, IonIcon, IonToolbar, IonTitle, IonButtons, IonBackButton, modalController } from '@ionic/vue'
import SongSheet from '@/components/SongSheet.vue'
import { apps, arrowUp, arrowDown } from 'ionicons/icons'
import TransposeControl from '@/components/TransposeControl.vue'
import TunerView from '@/views/TunerView.vue'

export default {
  components: { SongSheet, TransposeControl, IonPage, IonContent, IonPopover, IonHeader, IonFooter, IonButton, IonIcon, IonToolbar, IonTitle, IonButtons, IonBackButton },

  data () {
    return {
      songsheet: {},
      showTuner: false,
      source: '',
      key: 'C',
      transpose: 0,
      icons: { apps, arrowUp, arrowDown }
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

  watch: {
    $route: 'fetchData'
  },

  created () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      this.songsheet = (await client.get(`/api/songsheets/${this.$route.params.id}.json`)).data
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
    }
  }
}
</script>
