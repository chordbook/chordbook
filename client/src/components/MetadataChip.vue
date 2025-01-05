<script lang="ts" setup>
defineProps<{
  name: string;
  value?: string | number | null;
}>();
</script>

<template>
  <IonChip class="py-0">
    <div class="text-nowrap w-full inline-flex items-baseline gap-1 justify-center">
      <span class="opacity-70 uppercase text-xs">
        {{ name }}{{ value || $slots.default ? ":" : "" }}
      </span>
      <slot
        ><strong>{{ value }}</strong></slot
      >
    </div>
  </IonChip>
</template>
