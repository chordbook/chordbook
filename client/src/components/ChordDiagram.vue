<script setup>
import { Chord } from 'chordsheetjs'
import ChordData from '@/lib/chord-data'
import ChordBox from '@/components/ChordBox.vue'
import { computed } from 'vue'

const props = defineProps({
  as: {
    type: String,
    default: 'symbol'
  },
  chord: {
    type: Chord,
    required: true
  },
  instrument: {
    type: String,
    default: 'guitar'
  },
  position: {
    type: Number,
    default: 0
  }
})

const data = computed(() => ChordData.find(props.chord, props.instrument, props.position))
</script>

<template>
  <chord-box
    v-if="data"
    :id="`chord-${chord}`"
    :data="data"
    v-bind="$attrs"
  />
</template>
