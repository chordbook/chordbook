<template>
  <ion-item
    button
    :router-link="{ name: 'album', params: { id: album.id } }"
    class="rounded group"
    :detail="false"
    lines="none"
  >
    <ion-label>
      <div class="rounded overflow-hidden relative aspect-square shadow-md bg-slate-100 dark:bg-slate-900 mb-2 flex place-content-center items-center">
        <ion-img
          v-if="album.thumbnail"
          :src="album.thumbnail"
        />
        <ion-icon
          v-else
          :icon="icons.album"
          class="text-slate-300 text-5xl"
        />
        <ion-icon
          :id="`album-${album.id}-popover`"
          :ios="icons.iosEllipsis"
          :md="icons.mdEllipsis"
          class="absolute bottom-1 right-1 opacity-0 group-hover:opacity-100 transition-opacity block ratio-square rounded-full bg-black/50 text-white p-1.5 text-xs"
          @click.prevent=""
        />
      </div>
      <h2 class="text-sm">
        {{ album.title }}
      </h2>
      <p>
        <span v-if="showArtist">{{ album.artist.name }} •</span>
        {{ album.released }}
      </p>
    </ion-label>
    <ion-popover
      :trigger="`album-${album.id}-popover`"
      alignment="center"
      translucent
      dismiss-on-select
      animated
    >
      <ion-list lines="full">
        <ion-item
          button
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: album.artist?.id } }"
        >
          View Artist
        </ion-item>
      </ion-list>
    </ion-popover>
  </ion-item>
</template>

<script setup>
import { defineProps } from 'vue'
import { IonItem, IonLabel, IonImg, IonIcon, IonPopover, IonList } from '@ionic/vue'
import * as icons from '@/icons'

defineProps({
  album: {
    type: Object,
    required: true
  },
  showArtist: {
    type: Boolean,
    default: true
  }
})
</script>
