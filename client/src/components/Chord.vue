<script lang="ts" setup>
import ChordDiagramReference from "@/components/ChordDiagramReference.vue";
import { Popover, PopoverButton, PopoverPanel } from "@headlessui/vue";
import { Chord } from "chordsheetjs";
import { computed } from "vue";

const { name } = defineProps<{ name: string }>();

const formatted = computed(() => {
  return Chord.parse(name)?.toString({ useUnicodeModifier: true }) ?? name;
});
</script>

<template>
  <Popover class="relative chord mr-1" @click.stop>
    <PopoverButton as="span" role="button">
      {{ formatted }}
    </PopoverButton>
    <PopoverPanel
      class="absolute z-10 -translate-x-1/2 left-1/2 bottom-full mb-1 p-1 pb-0 rounded text-center bg-white dark:bg-slate-900 text-black dark:text-slate-50 border border-solid border-slate-200 dark:border-black/80 shadow-md"
    >
      <ChordDiagramReference :chord="name" width="60" height="80" />
    </PopoverPanel>
  </Popover>
</template>
