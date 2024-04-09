<script setup>
import { watch, computed } from 'vue'

defineProps({
  chords: {
    type: Array,
    default: () => []
  }
})

const transpose = defineModel('transpose', { type: Number, default: 0 })
const capo = defineModel('capo', { type: Number, default: 0 })

const steps = computed(() => {
  return [...Array(12).keys()].map(i => {
    const step = i - 5 // -5 to +6
    const capo = (12 - step + transpose.value) % 12
    return [step, capo]
  })
})

watch(transpose, () => { capo.value = 0 })
</script>

<template>
  <ion-modal ref="el">
    <ion-page>
      <ion-header>
        <ion-toolbar>
          <ion-title>Key</ion-title>
          <ion-buttons slot="end">
            <ion-button
              role="cancel"
              @click="$el.dismiss()"
            >
              Done
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content>
        <ion-list>
          <ion-item lines="full">
            <ion-label
              slot="start"
              color="primary"
            >
              Transpose
            </ion-label>
            <ion-label
              slot="end"
              color="tertiary"
            >
              Capo
            </ion-label>
          </ion-item>
          <ion-item
            v-for="[step, capoStep] in steps"
            :key="step"
            lines="full"
            :class="{ 'transpose-selected': step == transpose, 'capo-selected': capoStep === capo }"
          >
            <ion-button
              slot="start"
              class="w-10 text-center"
              :fill="step == transpose ? 'solid' : 'outline'"
              @click="transpose = step"
            >
              <template v-if="step > 0">
                +
              </template>
              {{ step }}
            </ion-button>

            <div
              class="flex flex-row flex-nowrap gap-2 mx-3 w-full overflow-auto"
            >
              <span
                v-for="chord in chords"
                :key="chord"
                class="text-nowrap min-w-12 first:ml-auto last:mr-auto"
              >
                {{ chord.transpose(step, { normalizeChordSuffix: true }).toString({ useUnicodeModifier: true }) }}
              </span>
            </div>

            <ion-button
              slot="end"
              class="w-10 text-center"
              color="tertiary"
              :fill="capoStep === capo ? 'solid' : 'outline'"
              @click="capo = capoStep"
            >
              {{ capoStep }}
            </ion-button>
          </ion-item>
        </ion-list>
      </ion-content>
    </ion-page>
  </ion-modal>
</template>

<style scoped>
ion-item.transpose-selected {
  /* --background: var(--ion-color-primary);
  --color: var(--ion-color-light); */
}

ion-item.capo-selected {
  --background: var(--ion-color-light);
}
</style>
