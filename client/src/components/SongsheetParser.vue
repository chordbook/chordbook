<script setup>
import { toRef, computed, reactive } from 'vue'
import useSongsheetParser from '@/composables/useSongsheetParser'
import useChords from '@/composables/useChords'

const props = defineProps({
  source: {
    type: String,
    default: null
  },
  transpose: {
    type: Number,
    default: 0
  }
})

const parser = reactive(useSongsheetParser(toRef(props, 'source')))

const transposed = computed(() => {
  if (props.transpose === 0) return parser.song
  return parser.song?.transpose(props.transpose, { normalizeChordSuffix: true })
})

const chords = useChords(transposed)
</script>

<template>
  <slot v-bind="{ ...parser, transposed, chords }" />
</template>
