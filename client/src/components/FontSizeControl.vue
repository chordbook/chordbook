<script lang="ts" setup>
import { useThemeStore } from "@/stores";
import { textOutline } from "ionicons/icons";

const theme = useThemeStore();
</script>

<template>
  <IonButton v-tooltip="'Decrease font size'" @click="theme.decreaseFontSize()">
    <IonIcon :icon="textOutline" class="text-base mt-1" />
  </IonButton>
  <IonButton v-tooltip="'Increase font size'" @click="theme.increaseFontSize()">
    <IonIcon :icon="textOutline" />
  </IonButton>
</template>
