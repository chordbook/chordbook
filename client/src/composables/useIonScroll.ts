import { unrefElement, useScroll } from "@vueuse/core";
import { ref, watchEffect } from "vue";

import type { MaybeElementRef, UseScrollReturn } from "@vueuse/core";
import type { Ref } from "vue";

export type UseIonScrollReturn = UseScrollReturn & {
  el: Ref<HTMLElement | undefined>;
};

// Extend useScroll with support for Ionic's ion-content element
export default function useIonScroll(scroller: MaybeElementRef): UseIonScrollReturn {
  const el = unrefIonScrollElement(scroller);
  return { el, ...useScroll(el) };
}

// Get they underlying scrollable element from and ion-content element
function unrefIonScrollElement(scroller: MaybeElementRef) {
  const el = ref<HTMLElement | undefined>();

  // Use async function with watchEffect since computed properties can't handle promises
  watchEffect(async () => {
    const value = unrefElement(scroller) as HTMLElement;
    // if scroller is an <ion-content> element, get the underlying scrollable element
    if ((value as HTMLIonContentElement)?.getScrollElement) {
      el.value = await (value as HTMLIonContentElement).getScrollElement();
    } else {
      el.value = value;
    }
  });

  return el;
}
