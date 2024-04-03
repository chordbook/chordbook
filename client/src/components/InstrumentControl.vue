<script setup>
const instruments = ['Guitar', 'Ukulele']
</script>

<template>
  <ion-select
    v-tooltip="'Instrument'"
    aria-label="Instrument"
    interface="popover"
    class="w-20"
  >
    <ion-select-option
      v-for="instrument in instruments"
      :key="instrument"
      :value="instrument.toLowerCase()"
    >
      {{ instrument }}
    </ion-select-option>
  </ion-select>
</template>
