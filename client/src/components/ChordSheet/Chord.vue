<script setup>
import ChordDiagramReference from "@/components/ChordDiagramReference.vue";
import { Popover, PopoverButton, PopoverPanel } from "@headlessui/vue";
import { computed } from "vue";
import { Chord } from "chordsheetjs";

const props = defineProps({
  name: {
    type: [String, undefined],
    default: undefined,
  },
});

const formatted = computed(() => {
  return Chord.parse(props.name)?.toString({ useUnicodeModifier: true }) ?? props.name;
});
</script>

<template>
  <Popover class="relative chord">
    <PopoverButton as="span" role="button">
      {{ formatted }}
    </PopoverButton>
    <PopoverPanel
      class="absolute z-10 -translate-x-1/2 left-1/2 bottom-full mb-1 p-1 pb-0 rounded text-center bg-white dark:bg-slate-900 text-black dark:text-slate-50 border border-solid border-slate-200 dark:border-black/80 shadow-md"
    >
      <chord-diagram-reference :chord="name" />
    </PopoverPanel>
  </Popover>
</template>
