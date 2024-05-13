import { ref, watch, computed } from "vue";
import { useElementSize, unrefElement, useEventListener } from "@vueuse/core";

export default function useHideOnScroll(scroll, target) {
  const { el, y: scrollTop, directions, arrivedState } = scroll;
  const targetRef = computed(() => unrefElement(target));
  const translateY = ref(0);
  const { height: scrollHeight } = useElementSize(targetRef);
  const lastScrollTop = ref(scrollTop.value);

  useEventListener(el, "click", () => {
    if (translateY.value < 0) {
      translateY.value = 0;
    } else {
      translateY.value = -targetRef.value.clientHeight;
    }
  });

  watch(scrollTop, () => {
    if (directions.bottom && scrollTop.value > 0 && !arrivedState.bottom) {
      translateY.value = Math.max(
        translateY.value - (scrollTop.value - lastScrollTop.value),
        -scrollHeight.value,
      );
    } else if (
      translateY.value < 0 &&
      (directions.top || arrivedState.bottom)
    ) {
      translateY.value = 0;
    }
    lastScrollTop.value = Math.max(0, scrollTop.value);
  });

  watch(translateY, (value) => {
    // Transition when revealing or fully hiding, otherwise immediately transform
    targetRef.value.classList.toggle(
      "transition-transform",
      value === 0 || value <= -targetRef.value.clientHeight,
    );
    targetRef.value.style.transform = `translateY(${value}px)`;
  });
}
