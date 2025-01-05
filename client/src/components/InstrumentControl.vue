<script lang="ts" setup>
import { Instrument } from "@/ChordData";

const instruments: Record<Instrument, string> = {
  [Instrument.Guitar]: "Guitar",
  [Instrument.Ukulele]: "Ukulele",
};
</script>

<template>
  <IonSelect v-tooltip="'Instrument'" aria-label="Instrument" interface="popover" class="w-20">
    <IonSelectOption v-for="(instrument, value) of instruments" :key="value" :value="value">
      {{ instrument }}
    </IonSelectOption>
  </IonSelect>
</template>
