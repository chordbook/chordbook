<script setup>
import SongSheet from '@/components/SongSheet.vue'
import SongsheetVersionsModal from '@/components/SongsheetVersionsModal.vue'
import SongsheetSettingsModal from '@/components/SongsheetSettingsModal.vue'
import SongsheetMedia from '@/components/SongsheetMedia.vue'
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import AddToSetlistModal from '@/components/AddToSetlistModal.vue'
import ShareItem from '@/components/ShareItem.vue'
import * as icons from '@/icons'
import { modalController, onIonViewDidEnter, onIonViewWillLeave } from '@ionic/vue'
import TunerView from '@/views/TunerView.vue'
import { Insomnia } from '@awesome-cordova-plugins/insomnia'
import useSongsheetSettings from '@/stores/songsheet-settings'
import { ref } from 'vue'

defineProps({
  id: {
    type: String,
    required: true
  }
})

const key = ref('C')
const settings = useSongsheetSettings()

onIonViewDidEnter(() => Insomnia.keepAwake())
onIonViewWillLeave(() => Insomnia.allowSleepAgain())

async function openTuner () {
  const modal = await modalController
    .create({
      component: TunerView,
      initialBreakpoint: 0.5,
      breakpoints: [0, 0.5]
    })
  return modal.present()
}

function formatDate (input) {
  if (!input) return ''
  const date = new Date(input)
  return new Intl.DateTimeFormat(navigator.language).format(date)
}

function hostname (url) {
  try {
    return new URL(url).hostname
  } catch (e) {
    return url
  }
}
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
              default-href="/songsheets"
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
            <ion-button :id="`settings-button-${id}`">
              <ion-icon
                slot="icon-only"
                :icon="icons.transpose"
              />
            </ion-button>
            <add-to-library-button
              :id="id"
            />
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
      <song-sheet
        v-if="songsheet.source"
        :source="songsheet.source"
        @update:key="(v) => key = v"
      >
        <template #top>
          <Transition name="slide-down">
            <songsheet-media
              v-if="settings.showPlayer"
              :media="songsheet.media"
            />
          </Transition>
        </template>
        <template
          v-if="songsheet.track"
          #header
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

      <Suspense>
        <!-- don't wait for modal to load -->
        <songsheet-versions-modal
          v-if="songsheet.track"
          :id="songsheet.track?.id"
          :trigger="`versions-button-${id}`"
          :exclude="id"
        />
      </Suspense>

      <songsheet-settings-modal
        :trigger="`settings-button-${id}`"
        :note="key"
      />
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
            @click="openTuner"
          >
            Tuner
          </ion-item>
        </ion-list>
      </ion-popover>
    </data-source>
  </app-view>
</template>
