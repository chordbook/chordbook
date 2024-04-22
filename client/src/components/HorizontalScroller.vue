<script setup>
import { chevronBackOutline, chevronForwardOutline } from 'ionicons/icons'
import { onMounted, ref } from 'vue'
import { useScroll, useEventListener } from '@vueuse/core'

defineOptions({
  inheritAttrs: false
})

const container = ref()
const scroller = ref()
const enabled = ref(false)
const { arrivedState, measure } = useScroll(scroller)

useEventListener(container, 'mouseenter', () => { enabled.value = true })
useEventListener(container, 'mouseleave', () => { enabled.value = false })

function scroll (pages = 1) {
  scroller.value.scrollBy({
    left: pages * scroller.value.clientWidth,
    behavior: 'smooth'
  })
}

onMounted(() => requestAnimationFrame(measure))
</script>

<template>
  <div
    ref="container"
    class="relative breakout"
  >
    <Transition name="fade">
      <ion-button
        v-show="enabled && !arrivedState.left"
        fill="clear"
        color="medium"
        shape="round"
        class="scroll-button -left-3 md:-left-7 lg:-left-10"
        @click="scroll(-1)"
      >
        <ion-icon
          slot="icon-only"
          :icon="chevronBackOutline"
          class="-ml-0.5"
        />
      </ion-button>
    </Transition>
    <div
      ref="scroller"
      class="z-0"
      v-bind="$attrs"
    >
      <slot />
    </div>
    <Transition name="fade">
      <ion-button
        v-show="enabled && !arrivedState.right"
        fill="clear"
        color="medium"
        shape="round"
        class="scroll-button -right-3 md:-right-7 lg:-right-10"
        @click="scroll(1)"
      >
        <ion-icon
          slot="icon-only"
          :icon="chevronForwardOutline"
          class="-mr-0.5"
        />
      </ion-button>
    </Transition>
  </div>
</template>

<style scoped>
/* Hack to force hover to overflow into the margins */
.breakout:before {
  content: " ";
  @apply absolute inset-y-0 -inset-x-12;
}

.scroll-button {
  @apply absolute z-10 top-0 bottom-0 flex flex-col items-center;
}

.scroll-button ion-icon {
  @apply sm:text-lg md:text-2xl lg:text-4xl;
}
</style>
