<script lang="ts" setup>
import { CupertinoPane, type CupertinoSettings } from "cupertino-pane";
import {
  computed,
  defineExpose,
  onBeforeUnmount,
  onMounted,
  ref,
  useTemplateRef,
  watchEffect,
} from "vue";

const {
  isOpen = false,
  canDismiss = false,
  settings = {},
} = defineProps<{
  isOpen?: boolean;
  canDismiss?: boolean;
  settings?: CupertinoSettings;
}>();

const emit = defineEmits<{
  "will-present": [pane: CupertinoPane];
  "did-present": [pane: CupertinoPane];
  "will-dismiss": [pane: CupertinoPane];
  "did-dismiss": [pane: CupertinoPane];
  "breakpoint-did-change": [breakpoint: Breaks];
}>();

const el = useTemplateRef("el");
const pane = ref<CupertinoPane>();
const height = ref(0);
const transition = ref("initial");

const config = computed<CupertinoSettings>(() => ({
  parentElement: el.value?.closest(".pane-container") as HTMLElement,
  buttonDestroy: false,
  ...settings,
  events: {
    onDidDismiss: () => emit("did-dismiss", pane.value!),
    onWillDismiss: () => emit("will-dismiss", pane.value!),
    onWillPresent: () => emit("will-present", pane.value!),
    onDidPresent: () => emit("did-present", pane.value!),
    onTransitionEnd: () =>
      requestAnimationFrame(() =>
        emit("breakpoint-did-change", pane.value!.currentBreak() as Breaks),
      ),
  },
}));

enum Breaks {
  top = "top",
  middle = "middle",
  bottom = "bottom",
}

onMounted(async () => {
  pane.value = new CupertinoPane(el.value!, config.value);

  pane.value.on("rendered", () => {
    const currentBreak = pane.value?.currentBreak() as Breaks;
    const breakSettings = pane.value!.settings.breaks![currentBreak];
    transition.value = pane.value!.transitions.buildTransitionValue(breakSettings?.bounce ?? false);
    height.value = breakSettings?.height ?? 0;
  });

  pane.value.on("onWillDismiss", () => {
    transition.value = "initial";
    height.value = 0;
  });

  pane.value.on("onMoveTransitionStart", ({ translateY }: { translateY: number }) => {
    transition.value = "initial";
    height.value = window.innerHeight - translateY;
  });

  pane.value.on(
    "onTransitionStart",
    ({ transition: t, translateY }: { transition: string; translateY: { new: number } }) => {
      transition.value = t;
      height.value = window.innerHeight - translateY.new;
    },
  );
});

watchEffect(() => {
  if (!pane.value) return;

  if (isOpen) {
    pane.value.present();
    pane.value.preventDismiss(!canDismiss);
  } else if (!pane.value.isHidden()) {
    pane.value.preventDismiss(false);
    pane.value.hide();
  }
});

onBeforeUnmount(async () => {
  pane.value?.preventDismiss(false);
  await pane.value?.destroy();
});

defineExpose({ pane, height, transition });
</script>

<template>
  <div ref="el">
    <slot />
  </div>
</template>

<style>
.pane {
  --ion-toolbar-background: var(--ion-color-step-150);
  --ion-toolbar-border-color: var(--ion-color-step-250);
  --cupertino-pane-background: var(--ion-color-step-100);
  --cupertino-pane-color: var(--ion-text-color);
}
</style>
