<script lang="ts" setup>
import type { Songsheet } from "@/api";
import { usePaginatedFetch } from "@/composables";
import * as icons from "@/icons";
import { computed } from "vue";
import ModelAvatar from "./ModelAvatar.vue";

const props = defineProps<{
  id: string;
  songsheetId: string;
}>();

const { items, load } = usePaginatedFetch<Songsheet[]>(`setlists/${props.id}/songsheets`);

const currentIndex = computed(() => {
  const index = items.value.findIndex(({ id }) => id === props.songsheetId);
  // Not found, load more and rely on reactivity to update this calculated value
  if (index < 0) load();
  return index;
});

// Previous will always be loaded if current is loaded
const prev = computed(() => currentIndex.value >= 0 && items.value[currentIndex.value - 1]);

const next = computed(() => {
  const songsheet = currentIndex.value >= 0 && items.value[currentIndex.value + 1];
  // Nothing found, load more and rely on reactivity to update this calculated value
  if (!songsheet) load();
  return songsheet;
});

await load();
</script>

<template>
  <DataSource v-slot="{ data }" :src="`setlists/${id}`">
    <IonFooter translucent>
      <IonToolbar class="relative flex items-center">
        <IonButtons v-if="prev" slot="start" class="w-1/2 lg:w-1/3">
          <IonItem
            button
            class="w-full"
            lines="none"
            :router-link="{
              name: 'setlistSongsheet',
              params: { id: prev.id, setlistId: id },
            }"
            detail="false"
          >
            <ModelAvatar
              slot="start"
              class="hidden md:block ml-2"
              :src="prev.track?.album?.cover?.small"
              type="Songsheet"
            />
            <IonLabel class="truncate">
              <p class="flex items-center gap-1">
                <IonIcon :icon="icons.playBack" size="small" />
                Previous
              </p>
              <h2 class="md:text-sm">
                {{ prev.title }}
              </h2>
            </IonLabel>
          </IonItem>
        </IonButtons>
        <IonTitle
          class="hidden lg:block"
          :router-link="{ name: 'setlist', params: { id } }"
          router-direction="back"
        >
          <div class="m-2">
            <IonNote class="block text-xs uppercase tracking-wider"> Setlist: </IonNote>
            {{ data.title }}
          </div>
        </IonTitle>
        <IonButtons v-if="next" slot="end" class="w-1/2 lg:w-1/3 flex justify-end">
          <IonItem
            button
            class="w-full"
            lines="none"
            :router-link="{
              name: 'setlistSongsheet',
              params: { id: next.id, setlistId: id },
            }"
            detail="false"
          >
            <ModelAvatar
              slot="end"
              class="hidden sm:block"
              :src="next.track?.album?.cover?.small"
              type="Songsheet"
            />
            <IonLabel class="text-right truncate text-sm">
              <p class="inline-flex items-center gap-1">
                Next
                <IonIcon :icon="icons.playNext" size="small" />
              </p>
              <h2 class="text-xs md:text-sm">
                {{ next.title }}
              </h2>
            </IonLabel>
          </IonItem>
        </IonButtons>
      </IonToolbar>
    </IonFooter>
  </DataSource>
</template>
