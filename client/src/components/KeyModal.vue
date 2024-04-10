<script setup>
import { watch, computed, ref } from 'vue'
import { Song, Key } from 'chordsheetjs'
import { useChords } from '@/composables'
import MetadataChip from '@/components/MetadataChip.vue'

const props = defineProps({
  song: {
    type: Song,
    required: true
  }
})

const transposeModel = defineModel('transpose', { type: Number, default: 0 })
const capoModel = defineModel('capo', { type: Number, default: 0 })
const modifier = ref('b')
const scroller = ref()
const keyEls = ref([])

const transpositions = computed(() => {
  return [...Array(12).keys()].map(i => {
    const step = i - 5 // -5 to +6
    const capo = (12 - step + transposeModel.value) % 12
    const transpose = step + capoModel.value - transposeModel.value
    const key = Key.wrap(props.song.key).transpose(transpose).useModifier(modifier.value).normalize()
    const chords = useChords(props.song).value.map(chord => chord.transpose(transpose).useModifier(modifier.value).normalize(key))
    return { step, capo, chords, key }
  })
})

watch(transposeModel, () => { capoModel.value = 0 })
watch([capoModel, transposeModel], scrollToActive)

async function scrollToActive (smooth = true) {
  requestAnimationFrame(() => {
    const index = transpositions.value.findIndex(({ capo }) => capoModel.value === capo)
    const el = keyEls.value[index]
    el.scrollIntoView({ behavior: smooth ? 'smooth' : 'auto', inline: 'center' })
  })
}
</script>

<template>
  <ion-modal
    ref="el"
    class="auto-height"
    :breakpoints="[0.25, 0.5, 1]"
    :initial-breakpoint="0.5"
    handle-behavior="cycle"
    @will-present="scrollToActive(false)"
  >
    <ion-header>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-segment
            slot="start"
            v-model="modifier"
          >
            <ion-segment-button value="b">
              <div class="text-xl -mb-1">
                ♭
              </div>
            </ion-segment-button>
            <ion-segment-button value="#">
              <div class="text-xl -mb-1">
                ♯
              </div>
            </ion-segment-button>
          </ion-segment>
        </ion-buttons>

        <ion-title>Transpose</ion-title>
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
    <div
      ref="scroller"
      class="flex flex-row flex-nowrap gap-1 ion-padding w-full overflow-auto snap-x snap-mandatory"
    >
      <div
        v-for="{ step, key, capo, chords } in transpositions"
        :key="step"
        ref="keyEls"
        class="w-24 snap-center first:snap-start last:snap-end shrink-0"
      >
        <div class="text-xs text-muted text-center">
          {{ step > 0 ? `+${step}` : step }}
        </div>
        <metadata-chip
          name="Key"
          :value="key.toString({ useUnicodeModifier: true })"
          :color="step === transposeModel ? 'tertiary' : 'medium'"
          :class="['w-full text-center items-center sticky mx-0', { 'key-selected': step === transposeModel }]"
          @click="transposeModel = step"
        />
        <div
          :class="{ 'chord-list': true, 'capo-selected': capo === capoModel }"
          @click="capoModel = capo"
        >
          <div class="text-center text-xs uppercase">
            <metadata-chip
              class="w-full mx-0 mt-0"
              :color="capo === capoModel ? 'primary' : 'medium'"
              :name="capo !== 0 ? 'Capo' : 'No capo'"
              :value="capo !== 0 ? capo : null"
            />
          </div>
          <div
            v-for="chord in chords"
            :key="chord"
            :class="['text-nowrap w-full text-center truncate', { 'opacity-25': capo !== capoModel }]"
          >
            {{ chord.toString({ useUnicodeModifier: true }) }}
          </div>
        </div>
      </div>
    </div>
  </ion-modal>
</template>

<style scoped>
.chord-list {
  @apply flex flex-col gap-3 pb-3 transition ease-in-out duration-300 rounded-[16px];
}

.capo-selected {
  @apply bg-indigo-50 dark:bg-slate-500/10;
}
</style>
