<script lang="ts" setup>
import ModelAvatar from "./ModelAvatar.vue";
import AddToSetlistModal from "@/components/AddToSetlistModal.vue";
import ShareItem from "@/components/ShareItem.vue";
import * as icons from "@/icons";

import type { Songsheet } from "@/api";

defineProps<
  Songsheet & {
    setlistId?: string;
  }
>();
</script>

<template>
  <IonItem
    button
    :router-link="{
      name: setlistId ? 'setlistSongsheet' : 'songsheet',
      params: { id, setlistId },
    }"
    detail="false"
  >
    <ModelAvatar slot="start" :src="track?.album?.cover?.medium" type="Songsheet" />
    <IonLabel class="truncate">
      <h2>{{ title }}</h2>
      <p v-if="subtitle">
        {{ subtitle }}
      </p>
    </IonLabel>
    <IonNote v-if="metadata.key || metadata.capo" slot="end" class="text-center w-10 text-nowrap">
      <div v-if="metadata.capo" class="text-[0.6rem] uppercase font-semibold opacity-80">
        Capo {{ metadata.capo }}
      </div>
      <span v-if="metadata.key" class="text-sm">
        {{ metadata?.key }}
      </span>
    </IonNote>
    <IonButton
      :id="`songsheet-${id}`"
      slot="end"
      class="hide-reorder"
      fill="clear"
      color="dark"
      @click.prevent=""
    >
      <IonIcon slot="icon-only" size="small" :ios="icons.iosEllipsis" :md="icons.mdEllipsis" />
    </IonButton>
    <IonReorder slot="end" />

    <IonPopover :trigger="`songsheet-${id}`" translucent dismiss-on-select>
      <IonList lines="full">
        <slot name="actions"></slot>
        <IonItem
          button
          detail
          :detail-icon="icons.setlist"
          @click="$refs.addToSetlistModal?.$el.present()"
        >
          <IonLabel>Add to Setlist…</IonLabel>
        </IonItem>
        <IonItem
          v-if="track"
          button
          detail
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: track?.artist?.id } }"
        >
          View Artist
        </IonItem>
        <IonItem
          v-if="track"
          button
          detail
          :detail-icon="icons.album"
          :router-link="{ name: 'album', params: { id: track?.album?.id } }"
        >
          View Album
        </IonItem>
        <ShareItem
          lines="none"
          :router-link="{ name: 'songsheet', params: { id } }"
          :title="[title, subtitle].join(' - ')"
        />
      </IonList>
    </IonPopover>
    <AddToSetlistModal :id="id" ref="addToSetlistModal" />
  </IonItem>
</template>
