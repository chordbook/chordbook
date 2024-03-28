<script setup>
const instruments = ['Guitar', 'Ukulele']
</script>

<template>
  <ion-select
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
