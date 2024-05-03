<!-- eslint-disable vue/prop-name-casing -->
<script setup>
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import AddToSetlistModal from '@/components/AddToSetlistModal.vue'
import ChordDiagram from '@/components/ChordDiagram.vue'
import ColumnLayout from '@/components/ColumnLayout.vue'
import FontSizeControl from '@/components/FontSizeControl.vue'
import FullscreenButton from '../components/FullscreenButton.vue'
import InstrumentControl from '@/components/InstrumentControl.vue'
import KeyModal from '../components/KeyModal.vue'
import SetlistSongsheetsPager from '../components/SetlistSongsheetsPager.vue'
import ShareItem from '@/components/ShareItem.vue'
import SongsheetChordsPane from '@/components/SongsheetChordsPane.vue'
import SongsheetContent from '@/components/SongsheetContent.vue'
import SongsheetMedia from '@/components/SongsheetMedia.vue'
import SongsheetVersionsModal from '@/components/SongsheetVersionsModal.vue'
import * as icons from '@/icons'
import { formatDate, hostname } from '@/util'
import { tabletPortraitOutline, tabletLandscapeOutline } from 'ionicons/icons'
import useSongsheetSettings from '@/stores/songsheet-settings'
import { ref, watch, computed, reactive, toRef, inject } from 'vue'
import { useResponsive, useIonScroll, useHideOnScroll, useAutoScroll, useSongsheetParser } from '@/composables'
import { useWakeLock } from '@vueuse/core'

defineOptions({ inheritAttrs: false })

const props = defineProps({
  id: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  source: {
    type: String,
    required: true
  },
  duration: {
    type: [Number, null],
    default: null
  },
  track: {
    type: [Object, null],
    default: null
  },
  media: {
    type: Array,
    default: () => []
  },
  updated_at: {
    type: [String, null],
    default: null
  },
  imported_from: {
    type: [String, null],
    default: null
  },
  setlistId: {
    type: String,
    default: null
  }
})

const parser = reactive(useSongsheetParser(toRef(props, 'source')))

const settings = useSongsheetSettings()
const scroller = ref() // template ref
const chordsPane = ref() // template ref
const header = ref() // template ref
const bigScreen = useResponsive('sm')
const wakelock = reactive(useWakeLock())

const scroll = useIonScroll(scroller)
useHideOnScroll(scroll, header)
const autoScrollAvailable = computed(() => settings.columns === 1)
const autoScrollDuration = computed(() => scroller.value?.$el?.dataset?.autoScrollDuration)
const autoScroll = reactive(useAutoScroll(scroll, autoScrollDuration))
const { onDidEnter, onWillLeave } = inject('page')

if (wakelock.isSupported) {
  onDidEnter(() => wakelock.request().catch(() => { }))
  onWillLeave(wakelock.release)
}

onDidEnter(() => {
  if (autoScrollAvailable.value && settings.autoScroll) {
    setTimeout(() => { autoScroll.start() }, 1000)
  }
})

onWillLeave(autoScroll.stop)

function toggleAutoScroll () {
  autoScroll.isActive ? autoScroll.stop() : autoScroll.start()
  settings.autoScroll = autoScroll.isActive
}

watch(() => settings.columns, () => scroller.value?.$el?.scrollToPoint(0, 0))
</script>

<template>
  <ion-header
    ref="header"
    translucent
  >
    <ion-toolbar>
      <ion-buttons slot="start">
        <ion-back-button
          v-tooltip="'Back'"
          text=""
          :default-href="setlistId ? { name: 'setlist', params: { id: setlistId} } : '/songsheets'"
        />
      </ion-buttons>
      <ion-buttons
        v-if="bigScreen"
        slot="start"
      >
        <instrument-control v-model="settings.instrument" />
      </ion-buttons>

      <ion-buttons class="mx-auto">
        <ion-segment
          v-if="bigScreen"
          :value="settings.columns"
          @ion-change="settings.columns = $event.detail.value"
        >
          <ion-segment-button
            v-tooltip="'Vertical scroll'"
            :value="1"
            layout="icon-start"
          >
            <ion-icon
              :icon="tabletPortraitOutline"
              size="small"
            />
          </ion-segment-button>
          <ion-segment-button
            v-tooltip="'Horizontal scroll'"
            :value="2"
            layout="icon-start"
          >
            <ion-icon
              :icon="tabletLandscapeOutline"
              size="small"
            />
          </ion-segment-button>
        </ion-segment>
      </ion-buttons>

      <ion-buttons slot="end">
        <fullscreen-button />
        <ion-button
          v-if="bigScreen"
          v-tooltip="settings.showPlayer ? 'Hide media player' : 'Show media player'"
          :color="settings.showPlayer ? 'secondary' : 'default'"
          :disabled="!media?.length > 0"
          @click="settings.showPlayer = !settings.showPlayer"
        >
          <ion-icon
            slot="icon-only"
            :icon="icons.play"
          />
        </ion-button>
        <font-size-control />
        <add-to-library-button :id="id" />
        <ion-button
          :id="`songsheet-context-${id}`"
          @click.prevent=""
        >
          <ion-icon
            slot="icon-only"
            :ios="icons.iosEllipsis"
            :md="icons.mdEllipsis"
          />
        </ion-button>
      </ion-buttons>
    </ion-toolbar>
  </ion-header>
  <ion-content
    ref="scroller"
    :data-auto-scroll-duration="duration || 3 * 60 * 1000"
    :scroll-y="settings.columns == 1 || parser.error"
    :scroll-x="settings.columns == 2 && !parser.error"
    fullscreen
    :class="{ autoscrolling: autoScroll.isActive }"
  >
    <column-layout
      :enabled="!parser.error && settings.columns == 2"
      class="relative ion-padding main-content"
    >
      <!-- Hidden sprite of chord diagrams -->
      <svg
        v-if="parser.song"
        hidden
        xmlns="http://www.w3.org/2000/svg"
      >
        <chord-diagram
          v-for="chord in parser.chords"
          :key="chord + settings.instrument"
          :chord="chord"
          :instrument="settings.instrument"
        />
      </svg>

      <div v-if="parser.error">
        <h1 class="text-xl md:text-2xl my-1">
          Error parsing songsheet
        </h1>

        <pre class="text-red-600 my-6">{{ parser.error }}</pre>

        <pre>{{ source }}</pre>
      </div>

      <songsheet-content
        v-if="parser.song"
        :id="`songsheet-content-${id}`"
        :song="parser.song"
      >
        <template
          v-if="track?.album"
          #album
        >
          <div
            v-if="track?.album"
            class="aspect-square w-12 shrink-0 sm:w-8 rounded overflow-hidden shadow flex place-content-center items-center bg-slate-100 dark:bg-slate-800"
          >
            <router-link
              :to="{ name: 'album', params: { id: track.album.id } }"
              @click.stop
            >
              <img :src="track?.album.cover?.medium">
            </router-link>
          </div>
        </template>

        <template
          v-if="track?.artist"
          #artist
        >
          <ion-label
            button
            :router-link="{ name: 'artist', params: { id: track.artist.id } }"
            class="block ion-activatable ion-focusable my-0 text-lg"
            @click.stop
          >
            <span class="text-muted">by </span>
            <span class="text-teal-500">{{ track.artist.name }}</span>
          </ion-label>
        </template>

        <template #media>
          <Transition name="slide-down">
            <songsheet-media
              v-if="settings.showPlayer"
              :media="media"
              class="no-print"
            />
          </Transition>
        </template>
      </songsheet-content>

      <div class="snap-end text-xs text-muted mb-8 flex flex-col md:flex-row gap-2">
        <div>Updated {{ formatDate(updated_at) }}</div>
        <div
          v-if="imported_from"
          class="md:ms-auto"
        >
          Imported from
          <a
            target="_blank"
            :href="imported_from"
            class="text-inherit no-underline"
          >
            {{ hostname(imported_from) }}
          </a>
        </div>
      </div>
    </column-layout>
    <div v-if="autoScrollAvailable" class="sticky h-0 bottom-0 right-0">
      <div class="absolute bottom-3 right-3 md:right-4 md:bottom-4 lg:right-8 lg:bottom-8 xl:right-12 xl:bottom-12">
        <ion-button
          v-tooltip.left="'Auto-scroll'"
          fill="clear"
          shape="round"
          size="small"
          :disabled="!scroller"
          class="p-0 shadow-md bg-white dark:bg-black rounded-full"
          @click.stop="toggleAutoScroll"
        >
          <ion-icon
            slot="icon-only"
            :icon="autoScroll?.isActive ? icons.autoScrollOn : icons.autoScrollOff"
            :class="{ 'text-4xl': true, 'animate-pulse': autoScroll.isActive }"
          />
        </ion-button>
      </div>
    </div>
    <songsheet-chords-pane
      ref="chordsPane"
      slot="fixed"
      :chords="parser.chords"
    />
    <Suspense>
      <setlist-songsheets-pager
        v-if="setlistId"
        :id="setlistId"
        :songsheet-id="id"
      />
    </Suspense>
    <div class="snap-end" />
  </ion-content>
  <key-modal
    v-model:transpose="parser.transpose"
    v-model:capo="parser.capo"
    v-model:modifier="parser.modifier"
    :song="parser.song"
    :trigger="`songsheet-content-${id}-key-metadata`"
  />

  <add-to-setlist-modal
    :id="id"
    ref="addToSetlistModal"
  />
  <ion-popover
    :trigger="`songsheet-context-${id}`"
    keep-contents-mounted
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
        :id="`versions-button-${id}`"
        button
        detail
        :detail-icon="icons.list"
        :disabled="!track || track.songsheets_count < 2"
      >
        Other Versions…
      </ion-item>
      <ion-item
        v-if="track?.artist"
        button
        detail
        :detail-icon="icons.artist"
        :router-link="{ name: 'artist', params: { id: track.artist.id } }"
      >
        View Artist
      </ion-item>
      <ion-item
        v-if="track?.album"
        button
        detail
        :detail-icon="icons.album"
        :router-link="{ name: 'album', params: { id: track.album.id } }"
      >
        View Album
      </ion-item>
      <share-item
        :title="title"
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
    <songsheet-versions-modal
      v-if="track"
      :id="track?.id"
      :trigger="`versions-button-${id}`"
      :exclude="id"
    />
  </ion-popover>
</template>

<style scoped>
ion-content::part(scroll) {
  --pane-height: calc(v-bind('chordsPane.height') * 1px);
  --padding-bottom: var(--pane-height);
  transition: v-bind('chordsPane.transition');
}

ion-content:not(.autoscrolling)::part(scroll) {
  @apply snap-both snap-proximity scroll-pb-[--pane-height];
}

@media (min-width: 576px) {
  ion-content::part(scroll), .maybe-sidebar {
    margin-left: calc(80px + env(safe-area-inset-left, 0));
  }
}

ion-buttons > * {
  @apply sm:mx-1 md:mx-2
}
</style>
