import { ref, toValue, watchEffect, computed, watch } from 'vue'
import { useScroll, useElementSize, useIntervalFn, useEventListener } from '@vueuse/core'

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
  const scrollHeight = computed(() => Math.max(el.value?.scrollHeight, height.value))
  const scrollDistance = computed(() => scrollHeight.value - height.value)

  const step = ref(0.1)
  const interval = computed(() => toValue(duration) / scrollDistance.value * step.value)
  const scrollTop = ref(0)
  const { y, arrivedState } = useScroll(el, { behavior: 'smooth', idle: interval })

  function scroll () {
    scrollTop.value += step.value
    y.value = scrollTop.value
  }
  const { pause, resume: start, isActive } = useIntervalFn(scroll, interval, { immediate: false })

  function resume () {
    scrollTop.value = el.value.scrollTop
    start()
  }

  function pauseAndResume () {
    if (!isActive.value) return
    pause()
    setTimeout(resume, 1000)
  }

  // Pause when arriving at the bottom
  watch(() => arrivedState.bottom, pause)

  // Pause when any of these events occur
  const pauseEvents = ['touchstart', 'mousedown', 'wheel']
  pauseEvents.forEach(event => { useEventListener(el, event, pauseAndResume) })

  return { pause, resume, isActive }
}
