import { computed, ref, toValue } from "vue";
import { useEventListener, useDebounceFn } from "@vueuse/core";

import type { Ref } from "vue";

// Keeps multiple scrollable elements in sync
export default function useScrollSync(...elements: Ref<HTMLElement>[]) {
  const refs = elements.map((el) => computed(() => toValue(el)));
  const activeScroller: Ref<HTMLElement | null> = ref(null);

  const doneScrolling = useDebounceFn(() => {
    activeScroller.value = null;
  }, 200);

  function onScroll(e: UIEvent) {
    const target = e.target as HTMLElement;

    if (activeScroller.value && activeScroller.value !== target) return;
    activeScroller.value = target;

    requestAnimationFrame(() => {
      const { scrollTop, scrollHeight, clientHeight } = target;
      const progress = scrollTop / (scrollHeight - clientHeight);

      refs.forEach((ref) => {
        if (ref.value && ref.value !== target) {
          ref.value.scrollTop =
            progress * (ref.value.scrollHeight - ref.value.clientHeight);
        }
      });

      doneScrolling();
    });
  }

  // Listen to scroll on all elements
  refs.forEach((ref) => useEventListener(ref, "scroll", onScroll));
}
