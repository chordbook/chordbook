import { ref, toValue, watchEffect, computed, watch } from 'vue'
import { useScroll, useElementSize, useIntervalFn, useEventListener, useResizeObserver } from '@vueuse/core'

export default function useAutoScroll (scroller, duration) {
  // the scrollable element, set in watchEffect below
  const el = ref()

  watchEffect(async () => {
    const value = toValue(scroller)
    // if scroller is an <ion-content> element, get the underlying scrollable element
    el.value = await (value?.$el?.getScrollElement?.() ?? value)
  })

  // Get dimensions of elements, calculate scroll interval
  const { height } = useElementSize(el)
  const scrollHeight = ref(null) // set in resize observer below
  const scrollDistance = computed(() => scrollHeight.value - height.value)
  const interval = computed(() => toValue(duration) / scrollDistance.value)
  const { y, arrivedState } = useScroll(el, { behavior: 'smooth', idle: interval })
  const step = ref(1) // Always 1px for now

  useResizeObserver(el, () => { scrollHeight.value = el.value?.scrollheight })

  function scroll () {
    y.value = y.value + step.value
  }

  const { pause, resume, isActive } = useIntervalFn(scroll, interval, { immediate: false })

  // Pause when arriving at the bottom
  watch(() => arrivedState.bottom, pause)

  // Pause when any of these events occur
  const pauseEvents = ['touchstart', 'mousedown', 'wheel']
  pauseEvents.forEach(event => { useEventListener(el, event, pause) })

  return { pause, resume, isActive }
}
