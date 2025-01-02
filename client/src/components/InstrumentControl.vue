<script lang="ts" setup>
import { Instrument } from "@/ChordData";

const instruments: Record<Instrument, string>  = {
  [Instrument.Guitar]: "Guitar",
  [Instrument.Ukulele]: "Ukulele"
};
</script>

<template>
  <ion-select
    v-tooltip="'Instrument'"
    aria-label="Instrument"
    interface="popover"
    class="w-20"
  >
    <ion-select-option
      v-for="(instrument, value) of instruments"
      :key="value"
      :value="value"
    >
      {{ instrument }}
    </ion-select-option>
  </ion-select>
</template>
