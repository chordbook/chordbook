<script setup>
import ChordLyricsPair from "./ChordLyricsPair.vue";
import Line from "./Line.vue";
import Literal from "./Literal.vue";
import SoftLineBreak from "./SoftLineBreak.vue";
import Tag from "./Tag.vue";
import { computed } from "vue";

const components = [
  Line,
  ChordLyricsPair,
  Tag,
  Literal,
  SoftLineBreak,
]

const props = defineProps({
  item: {
    type: Object,
    required: true,
  }
})

const itemComponent = computed(() => components.find((c) => props.item instanceof c.props.item))
</script>

<template>
  <component :is="itemComponent" :item="item" />
</template>
