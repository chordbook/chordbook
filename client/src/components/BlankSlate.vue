<script lang="ts" setup>
import * as icons from "@/icons";

defineProps<{
  icon: string;
  title: string;
  description?: string;
}>();
</script>

<template>
  <div
    class="flex flex-col justify-center items-center text-center min-h-screen-2/3 my-auto text-muted"
  >
    <ion-icon :icon="icons[icon as keyof typeof icons]" class="text-4xl" />
    <h2 class="bold text-3xl m-2">
      {{ title }}
    </h2>
    <p v-if="description">
      {{ description }}
    </p>
  </div>
</template>
