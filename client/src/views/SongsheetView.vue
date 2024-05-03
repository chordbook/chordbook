<script setup>
import Songsheet from '@/components/Songsheet.vue'
import { useIonPageLifecycle } from '@/composables'

defineProps({
  id: {
    type: String,
    required: true
  },
  setlistId: {
    type: String,
    default: null
  }
})

useIonPageLifecycle()
</script>

<template>
  <app-view class="pane-container">
    <data-source
      v-slot="{ data: songsheet }"
      :src="`songsheets/${id}`"
    >
      <Head>
        <title v-if="songsheet.track?.artist">
          {{ songsheet.title }}
          by
          {{ songsheet.track.artist.name }}
        </title>
        <title v-else>
          {{ songsheet.title }} - {{ songsheet.subtitle }}
        </title>
      </Head>
      <Songsheet
        v-bind="songsheet"
        :setlist-id="setlistId"
      />
    </data-source>
  </app-view>
</template>
