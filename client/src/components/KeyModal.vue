<script lang="ts" setup>
import MetadataChip from "@/components/MetadataChip.vue";
import { preferredModifierForKey } from "@/composables";
import { Chord, Key, Song } from "chordsheetjs";
import { computed, inject, ref, watch } from "vue";

import type { IonPageLifecycle } from "@/composables";

const props = defineProps<{
  song: Song;
}>();

const transposeModel = defineModel("transpose", { type: Number, default: 0 });
const capoModel = defineModel("capo", { type: Number, default: 0 });
const originalCapo = capoModel.value;
const modifier = defineModel<"#" | "b" | null>("modifier", { default: null });
const { onWillLeave } = inject<IonPageLifecycle>("page")!;
const modal = ref();
const scroller = ref();
const keyEls = ref<HTMLElement[]>([]);
const isChanged = computed(() => {
  return transposeModel.value !== 0 || capoModel.value !== originalCapo || modifier.value !== null;
});

const transpositions = computed(() => {
  return [...Array(12).keys()].map((i) => {
    const step = i - 5; // -5 to +6
    const capo = (12 - step + transposeModel.value) % 12;
    const transpose = step + capoModel.value - transposeModel.value;
    const key = Key.wrap(props.song.key)!
      .transpose(transpose)
      .useModifier(modifier.value)
      .normalize();
    const chordModifier = modifier.value || preferredModifierForKey(key.toString())!;
    const chords = props.song
      ?.getChords()
      .map((chord) =>
        Chord.parse(chord)!.transpose(transpose).useModifier(chordModifier).normalize(key),
      );

    return { step, capo, chords, key };
  });
});

async function scrollToActive(smooth = true) {
  requestAnimationFrame(() => {
    const index = transpositions.value.findIndex(
      ({ capo, step }) =>
        capoModel.value === capo && step === transposeModel.value - capoModel.value,
    );
    const el = keyEls.value[index];
    el.scrollIntoView({
      behavior: smooth ? "smooth" : "auto",
      inline: "center",
    });
  });
}

function reset() {
  transposeModel.value = 0;
  capoModel.value = originalCapo;
  modifier.value = null;
}

watch(transposeModel, () => {
  capoModel.value = 0;
});
watch([capoModel, transposeModel], () => scrollToActive());
onWillLeave(() => modal.value.$el.dismiss());
</script>

<template>
  <IonModal
    ref="modal"
    class="auto-height"
    :breakpoints="[0.25, 0.5, 1]"
    :initial-breakpoint="1"
    handle-behavior="cycle"
    @will-present="scrollToActive(false)"
  >
    <IonHeader>
      <IonToolbar>
        <IonButtons slot="start">
          <IonSegment v-model="modifier">
            <IonSegmentButton value="b">
              <div class="text-xl -mb-1">♭</div>
            </IonSegmentButton>
            <IonSegmentButton value="#">
              <div class="text-xl -mb-1">♯</div>
            </IonSegmentButton>
          </IonSegment>
        </IonButtons>

        <IonTitle>Transpose</IonTitle>
        <IonButtons slot="end">
          <IonButton :disabled="!isChanged" @click="reset"> Reset </IonButton>
          <IonButton role="cancel" @click="$el.dismiss()"> Done </IonButton>
        </IonButtons>
      </IonToolbar>
    </IonHeader>
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
        <MetadataChip
          name="Key"
          :value="key.toString({ useUnicodeModifier: true })"
          :color="step === transposeModel ? 'tertiary' : 'medium'"
          :class="[
            'w-full text-center items-center sticky mx-0',
            { 'key-selected': step === transposeModel },
          ]"
          @click="transposeModel = step"
        />
        <div
          :class="{ 'chord-list': true, 'capo-selected': capo === capoModel }"
          @click="capoModel = capo"
        >
          <div class="text-center text-xs uppercase">
            <MetadataChip
              class="w-full mx-0 mt-0"
              :color="capo === capoModel ? 'primary' : 'medium'"
              :name="capo !== 0 ? 'Capo' : 'No capo'"
              :value="capo !== 0 ? capo : null"
            />
          </div>
          <div
            v-for="chord in chords"
            :key="chord.toString()"
            :class="[
              'text-nowrap w-full text-center truncate',
              { 'opacity-25': capo !== capoModel },
            ]"
          >
            {{ chord.toString({ useUnicodeModifier: true }) }}
          </div>
        </div>
      </div>
    </div>
  </IonModal>
</template>

<style scoped>
.chord-list {
  @apply flex flex-col gap-3 pb-3 transition ease-in-out duration-300 rounded-[16px];
}

.capo-selected {
  @apply bg-indigo-50 dark:bg-slate-500/10;
}
</style>
