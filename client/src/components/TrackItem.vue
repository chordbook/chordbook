<template>
  <ion-item
    button
    :router-link="link"
    detail="false"
    :class="{ 'opacity-40 hover:opacity-100 transition-opacity': !track.has_songsheet }"
  >
    <ion-avatar slot="start">
      <img
        :src="track.album?.thumbnail"
        class="rounded"
      >
    </ion-avatar>
    <ion-label>
      <h2>{{ track.title }}</h2>
      <p>{{ track.artist.name }}</p>
    </ion-label>

    <ion-button
      :id="`track-${track.id}`"
      slot="end"
      fill="clear"
      color="medium"
      @click.prevent=""
    >
      <ion-icon
        slot="icon-only"
        size="small"
        :ios="icons.iosEllipsis"
        :md="icons.mdEllipsis"
      />
    </ion-button>
    <ion-popover
      :trigger="`track-${track.id}`"
      side="bottom"
      alignment="end"
      translucent
      dismiss-on-select
      animated
    >
      <ion-list lines="full">
        <ion-item
          v-if="!track.has_songsheet"
          button
          :router-link="{ name: 'songsheet.new', query: { track: track.id }}"
        >
          Create Songsheet
        </ion-item>
        <ion-item
          button
          detail
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: track.artist?.id } }"
        >
          View Artist
        </ion-item>
        <ion-item
          v-if="track.album"
          button
          detail
          :detail-icon="icons.album"
          :router-link="{ name: 'album', params: { id: track.album.id } }"
        >
          View Album
        </ion-item>
        <share-item
          lines="none"
          :router-link="link"
          :title="track.title"
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
  track: {
    type: Object,
    required: true
  }
})

const link = { name: 'track', params: { id: props.track.id } }
</script>
