<script setup>
import * as icons from "@/icons";
import ShareItem from "@/components/ShareItem.vue";
import ModelAvatar from "./ModelAvatar.vue";

defineProps({
  id: {
    type: String,
    required: true,
  },
  album: {
    type: Object,
    required: true,
  },
  artist: {
    type: Object,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  // eslint-disable-next-line vue/prop-name-casing
  has_songsheet: {
    type: Boolean,
    default: false,
  },
});
</script>

<template>
  <ion-item
    button
    :router-link="{ name: 'track', params: { id: id } }"
    detail="false"
    :class="{
      'opacity-40 hover:opacity-100 transition-opacity': !has_songsheet,
    }"
  >
    <model-avatar slot="start" :src="album?.cover?.small" type="Track" />
    <ion-label class="truncate">
      <h2>{{ title }}</h2>
      <p>{{ artist.name }}</p>
    </ion-label>

    <ion-button
      :id="`track-${id}`"
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
      :trigger="`track-${id}`"
      side="bottom"
      alignment="end"
      translucent
      dismiss-on-select
      animated
    >
      <ion-list lines="full">
        <ion-item
          v-if="!has_songsheet"
          button
          :router-link="{ name: 'songsheet.new', query: { track: id } }"
        >
          Create Songsheet
        </ion-item>
        <ion-item
          button
          detail
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: artist?.id } }"
        >
          View Artist
        </ion-item>
        <ion-item
          v-if="album"
          button
          detail
          :detail-icon="icons.album"
          :router-link="{ name: 'album', params: { id: album.id } }"
        >
          View Album
        </ion-item>
        <share-item lines="none" :router-link="link" :title="title" />
      </ion-list>
    </ion-popover>
  </ion-item>
</template>
