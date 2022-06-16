<template>
  <ion-item
    button
    :router-link="link"
    detail="false"
  >
    <ion-avatar
      slot="start"
      class="bg-slate-100 flex place-content-center items-center rounded"
    >
      <img
        v-if="songsheet.track?.album"
        :src="songsheet.track?.album?.thumbnail"
        class="rounded"
      >
      <ion-icon
        v-else
        :icon="icons.song"
        class="text-slate-300"
      />
    </ion-avatar>
    <ion-label>
      <h2>{{ songsheet.title }}</h2>
      <p v-if="artist">
        {{ artist }}
      </p>
    </ion-label>
    <ion-button
      :id="`songsheet-${songsheet.id}`"
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

    <ion-popover
      :trigger="`songsheet-${songsheet.id}`"
      translucent
      dismiss-on-select
    >
      <ion-list lines="full">
        <add-to-setlist-item :songsheet="songsheet" />
        <ion-item
          v-if="songsheet.track"
          button
          detail
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: songsheet.track?.artist?.id } }"
        >
          View Artist
        </ion-item>
        <ion-item
          v-if="songsheet.track"
          button
          detail
          :detail-icon="icons.album"
          :router-link="{ name: 'album', params: { id: songsheet.track?.album?.id } }"
        >
          View Album
        </ion-item>
        <share-item
          lines="none"
          :router-link="link"
          :title="songsheet.title"
        />
      </ion-list>
    </ion-popover>
  </ion-item>
</template>

<script>
import AddToSetlistItem from '@/components/AddToSetlistItem.vue'
import ShareItem from '@/components/ShareItem.vue'
import * as icons from '@/icons'

export default {
  components: { AddToSetlistItem, ShareItem },

  props: {
    songsheet: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      icons
    }
  },

  computed: {
    link () {
      return { name: 'songsheet', params: { id: this.songsheet.id } }
    },

    artist () {
      return this.songsheet?.artists
        ? new Intl.ListFormat().format(this.songsheet.artists.map(a => a.name))
        : this.songsheet.metadata?.subtitle
    }
  }
}
</script>
