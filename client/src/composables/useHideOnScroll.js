import { ref, watchEffect, watch, computed } from 'vue'
import { useScroll, useElementSize, unrefElement } from '@vueuse/core'

export default function useHideOnScroll (scroller, target) {
  const scrollerRef = ref()
  const targetRef = computed(() => unrefElement(target))
  const translateY = ref(0)
  const { height: scrollHeight } = useElementSize(targetRef)
  const { y: scrollTop, directions, arrivedState } = useScroll(scrollerRef)
  const lastScrollTop = ref(scrollTop.value)

  watchEffect(async () => {
    const el = unrefElement(scroller)
    // if scroller is an <ion-content> element, get the underlying scrollable element
    scrollerRef.value = await (el?.getScrollElement?.() ?? el)
  })

  watch(scrollTop, () => {
    if (directions.bottom && scrollTop.value > 0 && !arrivedState.bottom) {
      translateY.value = Math.max(translateY.value - (scrollTop.value - lastScrollTop.value), -scrollHeight.value)
    } else if (translateY.value < 0 && (directions.top || arrivedState.bottom)) {
      translateY.value = 0
    }
    lastScrollTop.value = Math.max(0, scrollTop.value)
  })

  watch(translateY, (value) => { targetRef.value.style.transform = `translateY(${value}px)` })
}
