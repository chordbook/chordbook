import { ref, toValue, watchEffect, computed } from 'vue'
import { useScroll, useElementSize, useEventListener, executeTransition, unrefElement } from '@vueuse/core'

export default function useAutoScroll (scroller, duration) {
  // the scrollable element, set in watchEffect below
  const el = ref()

  watchEffect(async () => {
    const value = unrefElement(scroller)
    // if scroller is an <ion-content> element, get the underlying scrollable element
    el.value = await (value?.getScrollElement?.() ?? value)
  })

  const { height } = useElementSize(el)
  const scrollHeight = computed(() => Math.max(el.value?.scrollHeight, height.value))
  const scrollDistance = computed(() => scrollHeight.value - height.value)
  const isActive = ref(false)
  const { y: scrollTop } = useScroll(el, { behavior: 'smooth' })

  async function start () {
    isActive.value = true
    const from = scrollTop.value
    const to = scrollDistance.value
    const currentDuration = toValue(duration) * (to - from) / to

    await executeTransition(scrollTop, from, to, {
      duration: currentDuration,
      abort: () => !isActive.value
    })

    isActive.value = false
  }

  async function stop () {
    isActive.value = false
  }

  function pauseAndResume () {
    if (!isActive.value) return
    stop()
    setTimeout(start, 1000)
  }

  // Pause when any of these events occur
  const pauseEvents = ['touchmove', 'wheel']
  pauseEvents.forEach(event => { useEventListener(el, event, pauseAndResume) })

  return { start, stop, isActive }
}
