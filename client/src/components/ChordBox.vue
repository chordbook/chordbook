<script setup>
import { ChordBox } from 'vexchords'
import ChordData from '@/ChordData'
import { computed } from 'vue'

const props = defineProps({
  as: {
    type: String,
    default: 'symbol'
  },
  data: {
    type: ChordData,
    required: true
  },
  width: {
    type: [Number, String],
    default: '50'
  },
  height: {
    type: [Number, String],
    default: '65'
  }
})

const diagram = computed(() => {
  if (!props.data) return ''

  const el = document.createElement('div')

  new ChordBox(el, {
    numStrings: props.data.strings,
    showTuning: false,
    width: props.width,
    height: props.height,
    defaultColor: 'currentColor'
  }).draw({
    chord: props.data.fingerings,
    position: props.data.data.baseFret,
    barres: props.data.barres
  })

  return el.querySelector('svg').innerHTML
})
</script>

<template>
  <!-- eslint-disable vue/no-v-html vue/no-v-text-v-html-on-component -->
  <component
    :is="as"
    :width="width"
    :height="height"
    :viewBox="`0 0 ${width} ${height}`"
    v-html="diagram"
  />
</template>
