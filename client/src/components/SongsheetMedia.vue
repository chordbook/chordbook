<script setup>
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from "@headlessui/vue";
import YoutubeEmbed from "@/components/YoutubeEmbed.vue";
import { closeOutline } from "ionicons/icons";
import useSongsheetSettings from "@/stores/songsheet-settings";

defineProps({
  media: {
    type: Array,
    required: true,
  },
});

const settings = useSongsheetSettings();
</script>

<template>
  <div
    v-if="media?.length > 0"
    class="z-10 order-1 md:sticky md:h-0 md:top-0 md:right-0"
  >
    <div class="main-content-x md:absolute md:right-0 top-4">
      <div
        class="shadow md:rounded-md overflow-hidden md:w-72 lg:w-96"
      >
        <TabGroup>
          <TabList
            v-show="media.length > 1"
            class="p-1 flex bg-slate-900"
          >
            <Tab
              v-for="(src, i) in media"
              v-slot="{ selected }"
              :key="src"
              as="template"
            >
              <ion-button :color="selected ? 'light' : 'medium'" size="small" class="outline-none">
                {{ i + 1 }}
              </ion-button>
            </Tab>
            <ion-button
              v-tooltip="'Hide media player'"
              fill="clear"
              size="small"
              color="light"
              class="ml-auto hidden md:block"
              @click="settings.showPlayer = false"
            >
              <ion-icon slot="icon-only" :icon="closeOutline" />
            </ion-button>

          </TabList>
          <TabPanels class="bg-black overflow-hidden">
            <TabPanel v-for="src in media" :key="src" class="relative">
              <youtube-embed :src="src" />
            </TabPanel>
          </TabPanels>
        </TabGroup>
      </div>
    </div>
  </div>
</template>
