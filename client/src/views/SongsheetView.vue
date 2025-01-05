<script setup lang="ts">
import Songsheet from "@/components/Songsheet.vue";
import { useIonPageLifecycle } from "@/composables";

import type { SongsheetFull } from "@/api";

defineProps<{
  id: string;
  setlistId?: string;
}>();

useIonPageLifecycle();
</script>

<template>
  <app-view class="pane-container">
    <data-source v-slot="{ data: songsheet }: { data: SongsheetFull }" :src="`songsheets/${id}`">
      <Head>
        <title v-if="songsheet.track?.artist">
          {{ songsheet.title }}
          by
          {{ songsheet.track.artist.name }}
        </title>
        <title v-else>{{ songsheet.title }} - {{ songsheet.subtitle }}</title>
      </Head>
      <Songsheet v-bind="songsheet" :setlist-id="setlistId" />
    </data-source>
  </app-view>
</template>
