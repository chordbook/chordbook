<script setup>
import { computed } from 'vue'
import * as icons from '@/icons'
import usePaginatedFetch from '@/composables/usePaginatedFetch'

const props = defineProps({
  id: {
    type: String,
    required: true
  },
  songsheetId: {
    type: String,
    required: true
  }
})

const { items, load } = usePaginatedFetch(`setlists/${props.id}/songsheets`)

const currentIndex = computed(() => items.findIndex(({ id }) => id === props.songsheetId))
const previousSongsheet = computed(() => items[currentIndex.value - 1])
const nextSongsheet = computed(() => {
  const songsheet = items[currentIndex.value + 1]
  if (songsheet) {
    return songsheet
  } else {
    // Nothing found, load more and rely on reactivity to update this calculated value
    load()
    return null
  }
})

</script>

<template>
  <data-source
    v-slot="{ data }"
    :src="`setlists/${id}`"
  >
    <ion-footer translucent>
      <ion-toolbar class="relative">
        <ion-buttons>
          <ion-button
            v-if="previousSongsheet"
            :router-link="{ name: 'setlistSongsheet', params: { id: previousSongsheet.id, setlistId: id }}"
            slot="start"
          >
            <ion-icon
              class="inline-block mr-2"
              :icon="icons.playBack"
            />
            {{ previousSongsheet.title }}
          </ion-button>
        </ion-buttons>
        <ion-title :router-link="{ name: 'setlist', params: { id }}" router-direction="back">
          <div>
            <ion-note class="block text-xs uppercase tracking-wider">
              Setlist:
            </ion-note>
            {{ data.title }}
          </div>

        </ion-title>
        <ion-buttons
          v-if="nextSongsheet"
          slot="end"
        >
          <ion-button :router-link="{ name: 'setlistSongsheet', params: { id: nextSongsheet.id, setlistId: id }}">
            {{ nextSongsheet.title }}
            <ion-icon
              class="inline-block ml-2"
              :icon="icons.playNext"
            />
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-footer>
  </data-source>
</template>
