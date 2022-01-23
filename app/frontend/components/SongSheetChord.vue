<template>
  <div>
    <Popover class="relative inline-block">
      <PopoverButton
        as="div"
        role="button"
        class="chord"
      >
        {{ name }}
      </PopoverButton>
      <PopoverPanel class="absolute z-10 transform -translate-x-1/2 left-1/2 bottom-full mb-1 p-1 pb-0 rounded text-center bg-slate-50 dark:bg-slate-900 text-black dark:text-slate-50 shadow border border-gray-200 dark:border-black/80">
        {{ name }}
        <svg
          class="chord-diagram"
          xmlns="http://www.w3.org/2000/svg"
          role="image"
          :title="name"
        >
          <use
            :xlink:href="`#chord-${name}`"
            viewBox="0 0 50 65"
          />
        </svg>
      </PopoverPanel>
    </Popover>
  </div>
</template>

<script>
import { Popover, PopoverButton, PopoverPanel } from '@headlessui/vue'

export default {
  components: { Popover, PopoverButton, PopoverPanel },

  props: {
    name: {
      type: [String, undefined],
      default: undefined
    }
  }
}
</script>
