<script setup>
import { Chord } from 'chordsheetjs'

defineProps({
  chord: {
    type: Chord,
    required: true
  }
})
</script>

<template>
  <svg
    class="chord-diagram inline-block"
    xmlns="http://www.w3.org/2000/svg"
    role="image"
    :title="chord.toString({ useUnicodeModifier: true })"
  >
    <use :xlink:href="`#chord-${chord}`" />
  </svg>
</template>
