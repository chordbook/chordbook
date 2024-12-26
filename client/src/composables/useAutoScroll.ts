import { ref, toValue, computed } from "vue";
import { useElementSize, useEventListener, executeTransition } from "@vueuse/core";

import type { MaybeRefOrGetter } from "vue";
import type { UseIonScrollReturn } from "./useIonScroll";

export default function useAutoScroll(scroll: UseIonScrollReturn, duration: MaybeRefOrGetter<number>) {
  const { y: scrollTop, el } = scroll;
  const { height } = useElementSize(el);
  const scrollHeight = computed(() =>
    Math.max(toValue(el)?.scrollHeight ?? 0, height.value),
  );
  const scrollDistance = computed(() => scrollHeight.value - height.value);
  const isActive = ref(false);

  async function start() {
    isActive.value = true;
    const from = scrollTop.value;
    const to = scrollDistance.value;
    const currentDuration = (toValue(duration) * (to - from)) / to;

    await executeTransition(scrollTop, from, to, {
      duration: currentDuration,
      abort: () => !isActive.value,
    });

    isActive.value = false;
  }

  async function stop() {
    isActive.value = false;
  }

  function pauseAndResume() {
    if (!isActive.value) return;
    stop();
    setTimeout(start, 1000);
  }

  // Pause when any of these events occur
  const pauseEvents = ["touchmove", "wheel"];
  pauseEvents.forEach((event) => {
    useEventListener(el, event, pauseAndResume);
  });

  return { start, stop, isActive };
}
