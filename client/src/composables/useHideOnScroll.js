import { ref, watch, computed } from 'vue'
import { useElementSize, unrefElement } from '@vueuse/core'

export default function useHideOnScroll (scroll, target) {
  const { y: scrollTop, directions, arrivedState } = scroll
  const targetRef = computed(() => unrefElement(target))
  const translateY = ref(0)
  const { height: scrollHeight } = useElementSize(targetRef)
  const lastScrollTop = ref(scrollTop.value)

  watch(scrollTop, () => {
    if (directions.bottom && scrollTop.value > 0 && !arrivedState.bottom) {
      targetRef.value.classList.remove('transition-transform')
      translateY.value = Math.max(translateY.value - (scrollTop.value - lastScrollTop.value), -scrollHeight.value)
    } else if (translateY.value < 0 && (directions.top || arrivedState.bottom)) {
      targetRef.value.classList.add('transition-transform')
      translateY.value = 0
    }
    lastScrollTop.value = Math.max(0, scrollTop.value)
  })

  watch(translateY, (value) => { targetRef.value.style.transform = `translateY(${value}px)` })
}
