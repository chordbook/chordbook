<script setup>
import { Song } from "chordsheetjs";
import { formatArray } from "@/util";
import MetadataChip from "@/components/MetadataChip.vue";

defineProps({
  song: Song,
  track: {
    type: Object,
    default: null,
  }
})
</script>

<template>
  <div
    class="order-2 md:order-1 flex flex-wrap md:flex-nowrap gap-2 md:gap-3 items-center md:items-center border-b border-slate-300 dark:border-slate-800 py-2"
  >
    <div
      v-if="track?.album"
      class="aspect-square w-12 shrink-0 sm:w-8 rounded overflow-hidden shadow flex place-content-center items-center bg-slate-100 dark:bg-slate-800"
    >
      <router-link
        :to="{ name: 'album', params: { id: track.album.id } }"
        @click.stop
      >
        <img :src="track?.album.cover?.medium" />
      </router-link>
    </div>

    <div class="flex flex-col sm:flex-row sm:items-baseline gap-x-1">
      <h1 class="text-xl md:text-2xl mr-1 truncate">
        {{ song.title }}
      </h1>

      <ion-label
        v-if="track?.artist"
        button
        :router-link="{ name: 'artist', params: { id: track.artist.id } }"
        class="block ion-activatable ion-focusable my-0 text-lg"
        @click.stop
      >
        <span class="text-muted">by </span>
        <span class="text-teal-500">{{ track.artist.name }}</span>
      </ion-label>
      <h2 v-else-if="song.subtitle" class="my-1 text-base">
        {{ song.subtitle }}
      </h2>
      <h2 v-else-if="song.artist" class="my-1">
        <span class="text-muted">by</span> {{ formatArray(song.artist) }}
      </h2>
    </div>
    <div
      :id="`${$attrs.id}-key-metadata`"
      class="w-full md:w-auto md:ml-auto flex flex-row gap-x-1"
    >
      <MetadataChip name="Key">
        <span class="chord pr-0">{{ song.metadata.get("_key") || song.key }}</span>
      </MetadataChip>
      <MetadataChip v-if="song.capo > 0" name="Capo" :value="song.capo" />
      <MetadataChip v-else name="No capo" />
    </div>
    <slot name="end" />
  </div>
</template>
