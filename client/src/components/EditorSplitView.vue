<script setup>
import { ref } from 'vue'
import { useMediaQuery } from '@vueuse/core'

const disabled = useMediaQuery('(max-width: 992px)')
const left = ref(null) // template ref
const right = ref(null) // template ref

function toggle () {
  if (!disabled.value) return
  const modal = right.value.$el
  modal.isOpen = !modal.isOpen
}

defineExpose({ disabled, toggle })
</script>

<template>
  <template v-if="disabled">
    <div class="h-full">
      <slot name="left" />

      <ion-modal ref="right">
        <ion-header translucent>
          <slot
            name="right-toolbar"
            v-bind="{ toggle }"
          />
        </ion-header>
        <ion-content fullscreen>
          <slot name="right" />
        </ion-content>
      </ion-modal>
    </div>
  </template>
  <template v-else>
    <div class="grid grid-cols-2 h-full">
      <div
        ref="left"
        class="h-full overflow-auto"
      >
        <slot name="left" />
      </div>
      <div
        ref="right"
        class="h-full overflow-auto"
      >
        <slot name="right" />
      </div>
    </div>
  </template>
</template>
