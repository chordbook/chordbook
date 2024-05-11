<script setup>
import { setlist } from "@/icons";
import { gradient } from "@/lib/gradient";

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
  thumbnails: {
    type: Array,
    required: true,
  },
});

function rotate(index) {
  if (index === 0) return 0;
  const spin = 360 / (props.thumbnails.length - 1);
  return (index - 1) * spin + "deg";
}
</script>

<template>
  <div
    class="rounded relative aspect-square shadow-md mb-2"
    :style="{ backgroundImage: gradient(id) }"
  >
    <template v-if="thumbnails.length > 0">
      <div
        v-for="(thumbnail, index) in thumbnails"
        :key="thumbnail"
        class="absolute inset-0 origin-center mix-blend-luminosity rotate-0"
        :style="{ '--tw-rotate': rotate(index) }"
      >
        <img
          :src="thumbnail"
          :class="{
            'absolute left-1/2 -translate-x-1/2 aspect-square bg-slate-800 origin-center -translate-y-1/2 rounded-full shadow-md': true,
            'top-1/2': index === 0,
            'top-[17.5%]': index !== 0,
            ['-' + rotate(index)]: true,
          }"
          :style="{
            width: index === 0 ? '35%' : '22%',
            '--tw-rotate': '-' + rotate(index),
          }"
        />
      </div>
    </template>

    <ion-icon
      v-else
      :icon="setlist"
      class="text-slate-100 text-3xl opacity-20 p-3 bg-slate-800 rounded-full absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2"
    />
  </div>
</template>
