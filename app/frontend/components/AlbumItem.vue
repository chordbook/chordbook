<template>
  <ion-item
    button
    :router-link="link"
    class="rounded group"
    :detail="false"
    lines="none"
  >
    <ion-label>
      <div class="rounded overflow-hidden relative aspect-square shadow-md bg-slate-100 dark:bg-slate-900 mb-2 flex place-content-center items-center">
        <img
          v-if="album.thumbnail"
          :src="album.thumbnail"
        >
        <ion-icon
          v-else
          :icon="icons.album"
          class="text-slate-300 text-5xl"
        />
        <ion-icon
          :id="`album-${album.id}-popover`"
          :ios="icons.iosEllipsis"
          :md="icons.mdEllipsis"
          class="absolute bottom-1 right-1 opacity-0 group-hover:opacity-100 transition-opacity block aspect-square rounded-full bg-black/50 text-white p-1.5 text-xs"
          @click.prevent=""
        />
      </div>
      <h3 class="text-sm">
        {{ album.title }}
      </h3>
      <p>
        <span v-if="showArtist">{{ album.artist.name }} •</span>
        {{ album.released }}
      </p>
    </ion-label>
    <ion-popover
      :trigger="`album-${album.id}-popover`"
      alignment="center"
      side="top"
      translucent
      dismiss-on-select
      animated
    >
      <ion-list lines="full">
        <ion-item
          button
          detail
          lines="none"
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: album.artist?.id } }"
        >
          View Artist
        </ion-item>
        <share-item
          lines="none"
          :router-link="link"
          :title="`${album.title} by ${album.artist.name}`"
        />
      </ion-list>
    </ion-popover>
  </ion-item>
</template>

<script setup>
import { defineProps } from 'vue'
import * as icons from '@/icons'
import ShareItem from '@/components/ShareItem.vue'

const props = defineProps({
  album: {
    type: Object,
    required: true
  },
  showArtist: {
    type: Boolean,
    default: true
  }
})

const link = { name: 'album', params: { id: props.album.id } }
</script>
