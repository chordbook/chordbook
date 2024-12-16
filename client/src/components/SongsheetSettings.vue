<script setup>
import FontSizeControl from "@/components/FontSizeControl.vue";
import { tabletPortraitOutline, tabletLandscapeOutline } from "ionicons/icons";
import { useResponsive } from "@/composables";
import useSongsheetSettings from "@/stores/songsheet-settings";

const bigScreen = useResponsive("sm");
const settings = useSongsheetSettings();
</script>

<template>
  <ion-popover>
    <ion-content>
      <ion-list lines="full">
        <font-size-control />
        <ion-item>
          <div class="w-full">
            <ion-label class="pb-2">
              Layout
            </ion-label>
            <ion-segment
              v-if="bigScreen"
              :value="settings.columns"
              @ion-change="settings.columns = $event.detail.value"
            >
              <ion-segment-button
                v-tooltip="'Vertical scroll'"
                :value="1"
                layout="icon-start"
              >
                <ion-icon :icon="tabletPortraitOutline" size="small" />
              </ion-segment-button>
              <ion-segment-button
                v-tooltip="'Horizontal scroll'"
                :value="2"
                layout="icon-start"
              >
                <ion-icon :icon="tabletLandscapeOutline" size="small" />
              </ion-segment-button>
            </ion-segment>
          </div>
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-popover>
</template>

<style scoped>
ion-popover {
  --min-width: 16rem;
}

ion-item {
  --padding-top: 0.5rem;
  --padding-bottom: 0.5rem;
}
</style>
