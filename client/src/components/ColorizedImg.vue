<script lang="ts" setup>
import { gradient } from "@/lib/gradient";

defineProps<{
  src: string;
  alt?: string;
}>();
</script>

<template>
  <div :style="`background-image: ${gradient(alt ?? src, { colors: 3, spin: 40 })}`">
    <img :src="src" class="object-cover w-full h-full opacity-70 mix-blend-luminosity" />
  </div>
</template>
