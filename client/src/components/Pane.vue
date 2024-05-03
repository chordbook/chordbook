<script setup>
import { CupertinoPane } from 'cupertino-pane'
import { ref, computed, onMounted, onBeforeUnmount, watchEffect, defineExpose } from 'vue'

const props = defineProps({
  isOpen: {
    type: Boolean,
    default: false
  },
  canDismiss: {
    type: Boolean,
    default: false
  },
  settings: {
    type: Object,
    default: () => ({})
  }
})

const emit = defineEmits(['will-present', 'did-present', 'will-dismiss', 'did-dismiss', 'breakpoint-did-change'])
const el = ref()
const pane = ref()
const height = ref(0)
const transition = ref('initial')

const settings = computed(() => (
  {
    parentElement: el.value?.closest('.pane-container'),
    buttonDestroy: false,
    ...props.settings,
    events: {
      onDidDismiss: () => emit('did-dismiss', pane.value),
      onWillDismiss: () => emit('will-dismiss', pane.value),
      onWillPresent: () => emit('will-present', pane.value),
      onDidPresent: () => emit('did-present', pane.value),
      onTransitionEnd: () => requestAnimationFrame(() => emit('breakpoint-did-change', pane.value.currentBreak()))
    }
  }
))

onMounted(async () => {
  pane.value = new CupertinoPane(el.value, settings.value)

  pane.value.on('rendered', () => {
    const currentBreak = pane.value.settings.breaks[pane.value.currentBreak()]
    transition.value = pane.value.transitions.buildTransitionValue(currentBreak?.bounce)
    height.value = currentBreak?.height ?? 0
  })

  pane.value.on('onWillDismiss', (ev) => {
    transition.value = 'initial'
    height.value = 0
  })

  pane.value.on('onMoveTransitionStart', (ev) => {
    transition.value = 'initial'
    height.value = window.innerHeight - ev.translateY
  })

  pane.value.on('onTransitionStart', (ev) => {
    transition.value = ev.transition
    height.value = window.innerHeight - ev.translateY.new
  })
})

watchEffect(() => {
  if (!pane.value) return

  if (props.isOpen) {
    pane.value.present()
    pane.value.preventDismiss(!props.canDismiss)
  } else if (!pane.value.isHidden()) {
    pane.value.preventDismiss(false)
    pane.value.hide()
  }
})

onBeforeUnmount(async () => {
  pane.value.preventDismiss(false)
  await pane.value.destroy()
})

defineExpose({ pane, height, transition })
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
