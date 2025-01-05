<script lang="ts" setup>
import * as icons from "@/icons";
import ShareItem from "./ShareItem.vue";

import type { Album } from "@/api";

const props = defineProps<
  Album & {
    showArtist?: boolean;
  }
>();

const link = { name: "album", params: { id: props.id } };
</script>

<template>
  <IonItem button :router-link="link" class="rounded group" :detail="false" lines="none">
    <IonLabel>
      <div
        class="rounded overflow-hidden relative aspect-square shadow-md bg-slate-100 dark:bg-slate-900 mb-2 flex place-content-center items-center"
      >
        <img v-if="cover" :src="cover.medium" />
        <IonIcon v-else :icon="icons.album" class="text-slate-300 text-5xl" />
        <IonIcon
          :id="`album-${id}-popover`"
          :ios="icons.iosEllipsis"
          :md="icons.mdEllipsis"
          class="absolute bottom-1 right-1 opacity-0 group-hover:opacity-100 transition-opacity block aspect-square rounded-full bg-black/50 text-white p-1.5 text-xs"
          @click.prevent=""
        />
      </div>
      <h3 class="text-sm">
        {{ title }}
      </h3>
      <p>
        <span v-if="showArtist ?? true">{{ artist.name }} •</span>
        {{ released }}
      </p>
    </IonLabel>
    <IonPopover
      :trigger="`album-${id}-popover`"
      alignment="center"
      side="top"
      translucent
      dismiss-on-select
      animated
    >
      <IonList lines="full">
        <IonItem
          button
          detail
          lines="none"
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: artist?.id } }"
        >
          View Artist
        </IonItem>
        <ShareItem lines="none" :router-link="link" :title="`${title} by ${artist.name}`" />
      </IonList>
    </IonPopover>
  </IonItem>
</template>
