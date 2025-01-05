<script setup lang="ts">
import AddToLibraryButton from "../components/AddToLibraryButton.vue";
import AddToSetlistModal from "@/components/AddToSetlistModal.vue";
import ColumnLayout from "@/components/ColumnLayout.vue";
import FontSizeControl from "@/components/FontSizeControl.vue";
import FullscreenButton from "../components/FullscreenButton.vue";
import InstrumentControl from "@/components/InstrumentControl.vue";
import KeyModal from "../components/KeyModal.vue";
import SetlistSongsheetsPager from "../components/SetlistSongsheetsPager.vue";
import ShareItem from "@/components/ShareItem.vue";
import SongsheetChordsPane from "@/components/SongsheetChordsPane.vue";
import SongsheetContent from "@/components/SongsheetContent.vue";
import SongsheetMedia from "@/components/SongsheetMedia.vue";
import SongsheetVersionsModal from "@/components/SongsheetVersionsModal.vue";
import * as icons from "@/icons";
import { formatDate, hostname } from "@/util";
import { tabletPortraitOutline, tabletLandscapeOutline } from "ionicons/icons";
import useSongsheetSettings from "@/stores/songsheet-settings";
import { ref, watch, computed, reactive, toRef, inject } from "vue";
import {
  useResponsive,
  useIonScroll,
  useHideOnScroll,
  useAutoScroll,
  useSongsheetParser,
  type IonPageLifecycle,
} from "@/composables";
import { useWakeLock } from "@vueuse/core";
import type { SongsheetFull } from "@/api";

defineOptions({ inheritAttrs: false });

const props = defineProps<
  SongsheetFull & {
    setlistId?: string;
  }
>();

const parser = reactive(useSongsheetParser(toRef(props, "source")));

const settings = useSongsheetSettings();
const scroller = ref(); // template ref
const chordsPane = ref(); // template ref
const header = ref(); // template ref
const bigScreen = useResponsive("sm");
const wakelock = reactive(useWakeLock());

const scroll = useIonScroll(scroller);
useHideOnScroll(scroll, header);
const autoScrollAvailable = computed(() => settings.columns === 1);
const autoScrollDuration = computed(() => scroller.value?.$el?.dataset?.autoScrollDuration);
const autoScroll = reactive(useAutoScroll(scroll, autoScrollDuration));
const { onDidEnter, onWillLeave } = inject<IonPageLifecycle>("page")!;

if (wakelock.isSupported) {
  onDidEnter(() => wakelock.request("screen").catch(() => {}));
  onWillLeave(wakelock.release);
}

onDidEnter(() => {
  if (autoScrollAvailable.value && settings.autoScroll) {
    setTimeout(() => {
      autoScroll.start();
    }, 1000);
  }
});

onWillLeave(autoScroll.stop);

function toggleAutoScroll() {
  settings.autoScroll = autoScroll.toggle();
}

watch(
  () => settings.columns,
  () => scroller.value?.$el?.scrollToPoint(0, 0),
);
</script>

<template>
  <IonHeader ref="header" translucent>
    <IonToolbar>
      <IonButtons slot="start">
        <IonBackButton
          v-tooltip="'Back'"
          text=""
          :default-href="setlistId ? { name: 'setlist', params: { id: setlistId } } : '/songsheets'"
        />
      </IonButtons>
      <IonButtons v-if="bigScreen" slot="start">
        <InstrumentControl v-model="settings.instrument" />
      </IonButtons>

      <IonButtons class="mx-auto">
        <IonSegment
          v-if="bigScreen"
          :value="settings.columns"
          @ion-change="settings.columns = $event.detail.value"
        >
          <IonSegmentButton v-tooltip="'Vertical scroll'" :value="1" layout="icon-start">
            <IonIcon :icon="tabletPortraitOutline" size="small" />
          </IonSegmentButton>
          <IonSegmentButton v-tooltip="'Horizontal scroll'" :value="2" layout="icon-start">
            <IonIcon :icon="tabletLandscapeOutline" size="small" />
          </IonSegmentButton>
        </IonSegment>
      </IonButtons>

      <IonButtons slot="end">
        <FullscreenButton />
        <IonButton
          v-if="bigScreen"
          v-tooltip="settings.showPlayer ? 'Hide media player' : 'Show media player'"
          :color="settings.showPlayer ? 'secondary' : 'default'"
          :disabled="!media || media.length == 0"
          @click="settings.showPlayer = !settings.showPlayer"
        >
          <IonIcon slot="icon-only" :icon="icons.play" />
        </IonButton>
        <FontSizeControl />
        <AddToLibraryButton :id="id" />
        <IonButton :id="`songsheet-context-${id}`" @click.prevent="">
          <IonIcon slot="icon-only" :ios="icons.iosEllipsis" :md="icons.mdEllipsis" />
        </IonButton>
      </IonButtons>
    </IonToolbar>
  </IonHeader>
  <IonContent
    ref="scroller"
    :data-auto-scroll-duration="duration || 3 * 60 * 1000"
    :scroll-y="settings.columns == 1 || parser.error"
    :scroll-x="settings.columns == 2 && !parser.error"
    fullscreen
    :class="{ autoscrolling: autoScroll.isActive }"
  >
    <SongsheetChordsPane
      v-if="parser.song"
      ref="chordsPane"
      slot="fixed"
      :chords="parser.chords"
      :definitions="parser.song.getChordDefinitions()"
    />
    <ColumnLayout
      :enabled="!parser.error && settings.columns == 2"
      class="relative ion-padding main-content"
    >
      <div v-if="parser.error">
        <h1 class="text-xl md:text-2xl my-1">Error parsing songsheet</h1>

        <pre class="text-red-600 my-6">{{ parser.error }}</pre>

        <pre>{{ source }}</pre>
      </div>

      <SongsheetContent v-if="parser.song" :id="`songsheet-content-${id}`" :song="parser.song">
        <template v-if="track?.album" #album>
          <div
            v-if="track?.album"
            class="aspect-square w-12 shrink-0 sm:w-8 rounded overflow-hidden shadow flex place-content-center items-center bg-slate-100 dark:bg-slate-800"
          >
            <RouterLink :to="{ name: 'album', params: { id: track.album.id } }" @click.stop>
              <img :src="track?.album.cover?.medium" />
            </RouterLink>
          </div>
        </template>

        <template v-if="track?.artist" #artist>
          <IonLabel
            button
            :router-link="{ name: 'artist', params: { id: track.artist.id } }"
            class="block ion-activatable ion-focusable my-0 text-lg"
            @click.stop
          >
            <span class="text-muted">by </span>
            <span class="text-teal-500">{{ track.artist.name }}</span>
          </IonLabel>
        </template>

        <template #media>
          <Transition name="slide-down">
            <SongsheetMedia v-if="settings.showPlayer" :media="media" class="no-print" />
          </Transition>
        </template>
      </SongsheetContent>

      <div class="snap-end text-xs text-muted mb-8 flex flex-col gap-1">
        <div>Updated {{ formatDate(updated_at) }}</div>
        <div v-if="imported_from">
          Imported from
          <a target="_blank" :href="imported_from" class="text-inherit no-underline">
            {{ hostname(imported_from) }}
          </a>
        </div>
        <div v-if="copyright">
          <a :href="copyright.url" rel="nofollow" class="text-xs text-muted">{{
            copyright.notice
          }}</a>
          <img class="w-0 h-0" loading="eager" :src="copyright.pixel_url" />
        </div>
      </div>
    </ColumnLayout>
    <div v-if="autoScrollAvailable" class="sticky h-0 bottom-0 right-0">
      <div
        class="absolute bottom-3 right-3 md:right-4 md:bottom-4 lg:right-8 lg:bottom-8 xl:right-12 xl:bottom-12"
      >
        <IonButton
          v-tooltip.left="'Auto-scroll'"
          fill="clear"
          shape="round"
          size="small"
          :disabled="!scroller"
          class="p-0 shadow-md bg-white dark:bg-black rounded-full"
          @click.stop="toggleAutoScroll"
        >
          <IonIcon
            slot="icon-only"
            :icon="autoScroll?.isActive ? icons.autoScrollOn : icons.autoScrollOff"
            :class="{ 'text-4xl': true, 'animate-pulse': autoScroll.isActive }"
          />
        </IonButton>
      </div>
    </div>
    <Suspense>
      <SetlistSongsheetsPager v-if="setlistId" :id="setlistId" :songsheet-id="id" />
    </Suspense>
    <div class="snap-end" />
  </IonContent>
  <KeyModal
    v-if="parser.song"
    v-model:transpose="parser.transpose"
    v-model:capo="parser.capo"
    v-model:modifier="parser.modifier"
    :song="parser.song"
    :trigger="`songsheet-content-${id}-key-metadata`"
  />

  <AddToSetlistModal :id="id" ref="addToSetlistModal" />
  <IonPopover :trigger="`songsheet-context-${id}`" keep-contents-mounted dismiss-on-select>
    <IonList>
      <IonItem
        button
        detail
        :router-link="{ name: 'songsheet.edit', params: { id } }"
        router-direction="replace"
        :detail-icon="icons.edit"
      >
        <IonLabel>Edit</IonLabel>
      </IonItem>
      <IonItem
        button
        detail
        :detail-icon="icons.setlist"
        @click="$refs.addToSetlistModal?.$el.present()"
      >
        <IonLabel>Add to Setlist…</IonLabel>
      </IonItem>
      <IonItem
        :id="`versions-button-${id}`"
        button
        detail
        :detail-icon="icons.list"
        :disabled="!track || track.songsheets_count < 2"
      >
        Other Versions…
      </IonItem>
      <IonItem
        v-if="track?.artist"
        button
        detail
        :detail-icon="icons.artist"
        :router-link="{ name: 'artist', params: { id: track.artist.id } }"
      >
        View Artist
      </IonItem>
      <IonItem
        v-if="track?.album"
        button
        detail
        :detail-icon="icons.album"
        :router-link="{ name: 'album', params: { id: track.album.id } }"
      >
        View Album
      </IonItem>
      <ShareItem :title="title" :router-link="{ name: 'songsheet', params: { id } }" />
      <IonItem button detail :detail-icon="icons.tuningFork" lines="none" router-link="#tuner">
        Tuner
      </IonItem>
    </IonList>
    <SongsheetVersionsModal
      v-if="track"
      :id="track?.id"
      :trigger="`versions-button-${id}`"
      :exclude="id"
    />
  </IonPopover>
</template>

<style scoped>
ion-content::part(scroll) {
  --pane-height: calc(v-bind("chordsPane.height") * 1px);
  --padding-bottom: var(--pane-height);
  transition: v-bind("chordsPane.transition");
}

ion-content:not(.autoscrolling)::part(scroll) {
  @apply snap-both snap-proximity scroll-pb-[--pane-height];
}

@media (min-width: 576px) {
  ion-content::part(scroll),
  .maybe-sidebar {
    margin-left: calc(80px + env(safe-area-inset-left, 0));
  }
}

ion-buttons > * {
  @apply sm:mx-1 md:mx-2;
}
</style>
