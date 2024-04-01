import { ref, watchEffect } from 'vue'
import { unrefElement, useScroll } from '@vueuse/core'

// Extend useScroll with support for Ionic's ion-content element
export default function useIonScroll (scroller) {
  const el = unrefIonScrollElement(scroller)
  return { el, ...useScroll(el) }
}

// Get they underlying scrollable element from and ion-content element
function unrefIonScrollElement (scroller) {
  const el = ref()

  // Use async function with watchEffect since computed properties can't handle promises
  watchEffect(async () => {
    const value = unrefElement(scroller)
    // if scroller is an <ion-content> element, get the underlying scrollable element
    el.value = await (value?.getScrollElement?.() ?? value)
  })

  return el
}
