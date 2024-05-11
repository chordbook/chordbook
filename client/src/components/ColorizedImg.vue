<script>
import { gradient } from "@/lib/gradient";

export default {
  props: {
    src: {
      type: String,
      required: true,
    },

    alt: {
      type: String,
      default: null,
    },
  },

  computed: {
    style() {
      return `background-image: ${gradient(this.alt || this.src, { colors: 3, spin: 40 })}`;
    },
  },
};
</script>

<template>
  <div :style="style">
    <img
      :src="src"
      class="object-cover w-full h-full opacity-70 mix-blend-luminosity"
    />
  </div>
</template>
