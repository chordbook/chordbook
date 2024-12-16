<script setup>
import { useThemeStore } from "@/stores";
import { text } from "@/icons";
import { IonRange } from "@ionic/vue";
import { computed } from "vue";

const theme = useThemeStore();
const fontIndex = computed({
  get() {
    return theme.fontSizes.indexOf(theme.fontSize);
  },

  set(index) {
    theme.fontSize = theme.fontSizes[index];
  },
});
</script>

<template>
  <ion-item>
    <div class="w-full">
      <ion-label>Font Size</ion-label>
      <ion-range v-model="fontIndex" class="px-0" :ticks="false" :snaps="true" :min="0" :max="theme.fontSizes.length - 1"
        aria-label="Font Size">
        <ion-button
          slot="start"
          v-tooltip="'Decrease font size'"
          fill="clear"
          @click="theme.decreaseFontSize()"
        >
          <ion-icon :icon="text" class="text-sm mt-1" />
        </ion-button>
        <ion-button
          slot="end"
          v-tooltip="'Increase font size'"
          fill="clear"
          @click="theme.increaseFontSize()"
        >
          <ion-icon :icon="text" class="text-xl" />
        </ion-button>

      </ion-range>
    </div>
  </ion-item>
</template>

<style scoped>
ion-range::part(label) {
  @apply my-0;
}
</style>
