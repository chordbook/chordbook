<script lang="ts" setup>
import { IonModal } from "@ionic/vue";
import { useMediaQuery } from "@vueuse/core";
import { useTemplateRef } from "vue";

const disabled = useMediaQuery("(max-width: 992px)");
const right = useTemplateRef<HTMLDivElement | typeof IonModal>("right");

function toggle() {
  if (!disabled.value || right.value) return;
  const modal = (right.value! as typeof IonModal).$el;
  modal.isOpen = !modal.isOpen;
}

defineExpose({ disabled, toggle });
</script>

<template>
  <template v-if="disabled">
    <div class="h-full">
      <slot name="left" />

      <ion-modal ref="right">
        <ion-header translucent>
          <slot name="right-toolbar" v-bind="{ toggle }" />
        </ion-header>
        <ion-content fullscreen>
          <slot name="right" />
        </ion-content>
      </ion-modal>
    </div>
  </template>
  <template v-else>
    <div class="grid grid-cols-2 h-full">
      <div class="h-full overflow-auto">
        <slot name="left" />
      </div>
      <div ref="right" class="h-full overflow-auto">
        <slot name="right" />
      </div>
    </div>
  </template>
</template>
