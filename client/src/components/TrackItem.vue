<script lang="ts" setup>
import * as icons from "@/icons";
import ShareItem from "@/components/ShareItem.vue";
import ModelAvatar from "./ModelAvatar.vue";

import type { Track } from "@/api";

defineProps<Track>();
</script>

<template>
  <IonItem
    button
    :router-link="{ name: 'track', params: { id: id } }"
    detail="false"
    :class="{
      'opacity-40 hover:opacity-100 transition-opacity': !has_songsheet,
    }"
  >
    <ModelAvatar slot="start" :src="album?.cover?.small" type="Track" />
    <IonLabel class="truncate">
      <h2>{{ title }}</h2>
      <p>{{ artist.name }}</p>
    </IonLabel>

    <IonButton :id="`track-${id}`" slot="end" fill="clear" color="medium" @click.prevent="">
      <IonIcon slot="icon-only" size="small" :ios="icons.iosEllipsis" :md="icons.mdEllipsis" />
    </IonButton>
    <IonPopover
      :trigger="`track-${id}`"
      side="bottom"
      alignment="end"
      translucent
      dismiss-on-select
      animated
    >
      <IonList lines="full">
        <IonItem
          v-if="!has_songsheet"
          button
          :router-link="{ name: 'songsheet.new', query: { track: id } }"
        >
          Create Songsheet
        </IonItem>
        <IonItem
          button
          detail
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: artist?.id } }"
        >
          View Artist
        </IonItem>
        <IonItem
          v-if="album"
          button
          detail
          :detail-icon="icons.album"
          :router-link="{ name: 'album', params: { id: album.id } }"
        >
          View Album
        </IonItem>
        <ShareItem lines="none" :router-link="{ name: 'track', params: { id } }" :title="title" />
      </IonList>
    </IonPopover>
  </IonItem>
</template>
