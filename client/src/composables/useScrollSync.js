import { ref, computed, toValue } from 'vue'
import { unrefElement, useEventListener } from '@vueuse/core'
import debounce from 'lodash.debounce'

// Keeps multiple scrollable elements in sync
export default function useScrollSync (...elements) {
  const refs = elements.map(el => computed(() => toValue(el)?.scroller ?? unrefElement(el)))
  let activeScroller = null

  const doneScrolling = debounce(() => { activeScroller = null }, 200)

  function onScroll (e) {
    const { target } = e

    if (activeScroller && activeScroller !== target) return
    activeScroller = e.target

    requestAnimationFrame(() => {
      const { scrollTop, scrollHeight, clientHeight } = target
      const progress = scrollTop / (scrollHeight - clientHeight)

      refs.forEach(ref => {
        if (ref.value && ref.value !== target) {
          ref.value.scrollTop = progress * (ref.value.scrollHeight - ref.value.clientHeight)
        }
      })

      doneScrolling()
    })
  }

  // Listen to scroll on all elements
  refs.forEach(ref => useEventListener(ref, 'scroll', onScroll))
}
