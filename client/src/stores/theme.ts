import { defineStore } from "pinia";
import { useStorage } from "@vueuse/core";

const sizes = ["sm", "md", "lg", "xl", "2xl", "3xl"];

export default defineStore("Theme", {
  state: () => ({
    fontSize: useStorage("fontSize", "md"),
  }),

  actions: {
    increaseFontSize() {
      const size = sizes[sizes.indexOf(this.fontSize) + 1];
      if (size) this.fontSize = size;
    },

    decreaseFontSize() {
      const size = sizes[sizes.indexOf(this.fontSize) - 1];
      if (size) this.fontSize = size;
    },

    reset() {},
  },
});
