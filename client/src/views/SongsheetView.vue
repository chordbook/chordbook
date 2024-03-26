<script setup>
import AutoScroll from '@/components/AutoScroll.vue'
import SongsheetContent from '@/components/SongsheetContent.vue'
import SongsheetParser from '@/components/SongsheetParser.vue'
import SongsheetVersionsModal from '@/components/SongsheetVersionsModal.vue'
import SongsheetSettingsModal from '@/components/SongsheetSettingsModal.vue'
import ChordDiagram from '@/components/ChordDiagram.vue'
import SongsheetMedia from '@/components/SongsheetMedia.vue'
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import AddToSetlistModal from '@/components/AddToSetlistModal.vue'
import SetlistSongsheetsPager from '../components/SetlistSongsheetsPager.vue'
import ShareItem from '@/components/ShareItem.vue'
import * as icons from '@/icons'
import { onIonViewDidEnter, onIonViewWillLeave } from '@ionic/vue'
import { Insomnia } from '@awesome-cordova-plugins/insomnia'
import useSongsheetSettings from '@/stores/songsheet-settings'
import { ref, watch, computed } from 'vue'
import { formatDate, hostname } from '@/util'

defineProps({
  id: {
    type: String,
    required: true
  },
  setlistId: {
    type: String,
    default: null
  }
})

const settings = useSongsheetSettings()
const scroller = ref() // template ref
const output = ref(null) // template ref
const columnWidth = ref(0)
const autoScrollAvailable = computed(() => settings.columns === 1)

settings.resetTranspose()

onIonViewDidEnter(() => {
  Insomnia.keepAwake()

  if (autoScrollAvailable.value && settings.autoScroll) {
    setTimeout(() => { scroller.value.start() }, 1000)
  }
})

onIonViewWillLeave(() => {
  scroller.value.stop()
  Insomnia.allowSleepAgain()
})

function updateColumnWidth () {
  if (!output.value) return

  output.value.classList.add('content-width')
  requestAnimationFrame(() => {
    columnWidth.value = output.value.offsetWidth + 'px'
    output.value.classList.remove('content-width')
  })
}

function toggleAutoScroll () {
  scroller.value.isActive ? scroller.value.stop() : scroller.value.start()
  settings.autoScroll = scroller.value.isActive
}

watch(() => settings.columns, updateColumnWidth)
watch(output, updateColumnWidth)
</script>

<template>
  <app-view>
    <data-source
      v-slot="{ data: songsheet }"
      :src="`songsheets/${id}`"
    >
      <Head>
        <title v-if="songsheet.track?.artist">
          {{ songsheet.title }}
          by
          {{ songsheet.track.artist.name }}
        </title>
        <title v-else>
          {{ songsheet.title }} - {{ songsheet.subtitle }}
        </title>
      </Head>
      <ion-header translucent>
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-back-button
              text=""
              :default-href="setlistId ? { name: 'setlist', params: { id: setlistId} } : '/songsheets'"
            />
            <ion-button
              :id="`versions-button-${id}`"
              :disabled="!songsheet.track || songsheet.track.songsheets_count < 2"
            >
              <ion-icon
                slot="icon-only"
                :icon="icons.list"
              />
            </ion-button>
          </ion-buttons>

          <ion-buttons slot="end">
            <ion-button
              v-if="scroller && autoScrollAvailable"
              @click="toggleAutoScroll"
            >
              <ion-icon
                slot="icon-only"
                :icon="scroller.isActive ? icons.pause : icons.play"
              />
              <ion-label>Auto-scroll</ion-label>
            </ion-button>
            <ion-button :id="`settings-button-${id}`">
              <ion-icon
                slot="icon-only"
                :icon="icons.transpose"
              />
            </ion-button>
            <add-to-library-button :id="id" />
            <ion-button
              :id="`songsheet-context-${id}`"
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
      <songsheet-parser
        v-slot="{ song, key, transposed, chords, error }"
        :source="songsheet.source"
        :transpose="settings.transpose"
      >
        <auto-scroll
          ref="scroller"
          :duration="songsheet.duration || 3 * 60 * 1000"
          :scroll-y="settings.columns == 1 || error"
          :scroll-x="settings.columns == 2 && !error"
          fullscreen
        >
          <Transition name="slide-down">
            <songsheet-media
              v-if="settings.showPlayer"
              :media="songsheet.media"
              class="no-print"
            />
          </Transition>
          <div :class="'ion-padding ' + (settings.columns == 1 || error ? 'single-column' : 'horizontal-columns')">
            <!-- Hidden sprite of chord diagrams -->
            <svg
              v-if="transposed"
              hidden
              xmlns="http://www.w3.org/2000/svg"
            >
              <chord-diagram
                v-for="chord in chords"
                :key="chord + settings.instrument"
                :chord="chord"
                :instrument="settings.instrument"
              />
            </svg>

            <div ref="output">
              <div v-if="error">
                <h1 class="text-xl md:text-2xl my-1">
                  Error parsing songsheet
                </h1>

                <pre class="text-red-600 my-6">{{ error }}</pre>

                <pre>{{ songsheet.source }}</pre>
              </div>
              <songsheet-content
                v-if="transposed"
                :song="transposed"
                class="mt-2 lg:text-lg"
              >
                <template
                  v-if="songsheet.track"
                  #title
                >
                  <div class="flex gap-3 md:gap-4 items-center">
                    <div
                      v-if="songsheet.track?.album"
                      class="aspect-square w-20 rounded overflow-hidden shadow-lg flex place-content-center items-center bg-slate-100 dark:bg-slate-800"
                    >
                      <img :src="songsheet.track?.album.cover?.medium">
                    </div>

                    <div>
                      <h1 class="text-xl md:text-2xl my-1">
                        {{ songsheet.title }}
                      </h1>

                      <ion-label
                        v-if="songsheet.track.artist"
                        button
                        :router-link="{ name: 'artist', params: { id: songsheet.track.artist.id } }"
                        class="block ion-activatable ion-focusable my-0"
                      >
                        <span class="text-muted">by </span>
                        <span class="text-teal-500">{{ songsheet.track.artist.name }}</span>
                      </ion-label>
                      <ion-label
                        v-if="songsheet.track.album"
                        button
                        :router-link="{ name: 'album', params: { id: songsheet.track.album.id } }"
                        class="block ion-activatable ion-focusable truncate overflow-hidden my-1"
                      >
                        <span class="text-muted">from </span>
                        <span class="text-teal-500">{{ songsheet.track.album.title }}</span>
                      </ion-label>
                    </div>
                  </div>
                </template>
              </songsheet-content>
            </div>
          </div>
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
        </auto-scroll>
        <ion-footer
          v-if="settings.showChords && transposed"
          translucent
        >
          <ion-toolbar translucent>
            <div class="flex gap-2 overflow-x-auto place-content-center pt-2 px-4">
              <div
                v-for="chord in chords"
                :key="chord"
                class="text-center text-sm"
              >
                <div class="chord">
                  {{ chord.toString({ useUnicodeModifier: true}) }}
                </div>
                <svg
                  class="chord-diagram inline-block"
                  xmlns="http://www.w3.org/2000/svg"
                  role="image"
                  :title="chord.toString({ useUnicodeModifier: true })"
                >
                  <use
                    :xlink:href="`#chord-${chord}`"
                    viewBox="0 0 50 65"
                  />
                </svg>
              </div>
            </div>
          </ion-toolbar>
        </ion-footer>
        <setlist-songsheets-pager
          v-if="setlistId"
          :id="setlistId"
          :songsheet-id="id"
        />
        <songsheet-settings-modal
          v-if="song"
          :trigger="`settings-button-${id}`"
          :note="key"
        />
      </songsheet-parser>

      <Suspense>
        <!-- don't wait for modal to load -->
        <songsheet-versions-modal
          v-if="songsheet.track"
          :id="songsheet.track?.id"
          :trigger="`versions-button-${id}`"
          :exclude="id"
        />
      </Suspense>

      <add-to-setlist-modal
        :id="id"
        ref="addToSetlistModal"
      />
      <ion-popover
        :trigger="`songsheet-context-${id}`"
        dismiss-on-select
      >
        <ion-list>
          <ion-item
            button
            detail
            :router-link="{ name: 'songsheet.edit', params: { id } }"
            router-direction="replace"
            :detail-icon="icons.edit"
          >
            <ion-label>Edit</ion-label>
          </ion-item>
          <ion-item
            button
            detail
            :detail-icon="icons.setlist"
            @click="$refs.addToSetlistModal.$el.present()"
          >
            <ion-label>Add to Setlist…</ion-label>
          </ion-item>
          <ion-item
            v-if="songsheet.track?.artist"
            button
            detail
            :detail-icon="icons.artist"
            :router-link="{ name: 'artist', params: { id: songsheet.track.artist.id } }"
          >
            View Artist
          </ion-item>
          <ion-item
            v-if="songsheet.track?.album"
            button
            detail
            :detail-icon="icons.album"
            :router-link="{ name: 'album', params: { id: songsheet.track.album.id } }"
          >
            View Album
          </ion-item>
          <share-item
            :title="songsheet.title"
            :router-link="{ name: 'songsheet', params: { id }}"
          />
          <ion-item
            button
            detail
            :detail-icon="icons.tuningFork"
            lines="none"
            router-link="#tuner"
          >
            Tuner
          </ion-item>
        </ion-list>
      </ion-popover>
    </data-source>
  </app-view>
</template>

<style>
.horizontal-columns {
  @apply h-full;
  column-count: auto;
  column-width: v-bind(columnWidth);
  max-width: 50%;
}

.content-width {
  overflow: auto !important;
  max-width: max-content !important;
  min-width: max-content !important;
  width: max-content !important;
  display: inline-block !important;
  flex-wrap: nowrap !important;
  padding: none !important;
}

.content-width .row {
  flex-wrap: nowrap !important;
}

.capo {
  @apply font-semibold text-sm text-zinc-600 break-after-avoid;
}
</style>
