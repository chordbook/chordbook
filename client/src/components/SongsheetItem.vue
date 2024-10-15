<script setup>
import ModelAvatar from "./ModelAvatar.vue";
import AddToSetlistModal from "@/components/AddToSetlistModal.vue";
import ShareItem from "@/components/ShareItem.vue";
import * as icons from "@/icons";

defineProps({
  id: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  subtitle: {
    type: String,
    required: true,
  },
  track: {
    type: Object,
    default: null,
  },
  metadata: {
    type: Object,
    default() {
      return {};
    },
  },
  setlistId: {
    type: String,
    default: null,
  },
});
</script>

<template>
  <ion-item
    button
    :router-link="{
      name: setlistId ? 'setlistSongsheet' : 'songsheet',
      params: { id, setlistId },
    }"
    detail="false"
  >
    <model-avatar
      slot="start"
      :src="track?.album?.cover?.medium"
      type="Songsheet"
    />
    <ion-label class="truncate">
      <h2>{{ title }}</h2>
      <p v-if="subtitle">
        {{ subtitle }}
      </p>
    </ion-label>
    <ion-note
      v-if="metadata.key || metadata.capo"
      slot="end"
      class="text-center w-10 text-nowrap"
    >
      <div
        v-if="metadata.capo"
        class="text-[0.6rem] uppercase font-semibold opacity-80"
      >
        Capo {{ metadata.capo }}
      </div>
      <span v-if="metadata.key" class="text-sm">
        {{ metadata?.key }}
      </span>
    </ion-note>
    <ion-button
      :id="`songsheet-${id}`"
      slot="end"
      class="hide-reorder"
      fill="clear"
      color="dark"
      @click.prevent=""
    >
      <ion-icon
        slot="icon-only"
        size="small"
        :ios="icons.iosEllipsis"
        :md="icons.mdEllipsis"
      />
    </ion-button>
    <ion-reorder slot="end" />

    <ion-popover :trigger="`songsheet-${id}`" translucent dismiss-on-select>
      <ion-list lines="full">
        <slot name="actions"></slot>
        <ion-item
          button
          detail
          :detail-icon="icons.setlist"
          @click="$refs.addToSetlistModal.$el.present()"
        >
          <ion-label>Add to Setlist…</ion-label>
        </ion-item>
        <ion-item
          v-if="track"
          button
          detail
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: track?.artist?.id } }"
        >
          View Artist
        </ion-item>
        <ion-item
          v-if="track"
          button
          detail
          :detail-icon="icons.album"
          :router-link="{ name: 'album', params: { id: track?.album?.id } }"
        >
          View Album
        </ion-item>
        <share-item
          lines="none"
          :router-link="{ name: 'songsheet', params: { id } }"
          :title="[title, subtitle].join(' - ')"
        />
      </ion-list>
    </ion-popover>
    <add-to-setlist-modal :id="id" ref="addToSetlistModal" />
  </ion-item>
</template>
