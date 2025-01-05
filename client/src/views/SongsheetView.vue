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
  <AppView class="pane-container">
    <DataSource v-slot="{ data: songsheet }: { data: SongsheetFull }" :src="`songsheets/${id}`">
      <Head>
        <title v-if="songsheet.track?.artist">
          {{ songsheet.title }}
          by
          {{ songsheet.track.artist.name }}
        </title>
        <title v-else>{{ songsheet.title }} - {{ songsheet.subtitle }}</title>
      </Head>
      <Songsheet v-bind="songsheet" :setlist-id="setlistId" />
    </DataSource>
  </AppView>
</template>
