import { defineStore } from "pinia";
import { useStorage } from "@vueuse/core";

export default defineStore("Theme", {
  state: () => ({
    fontSize: useStorage("fontSize", "md"),
  }),

  getters: {
    fontSizes() {
      return ["sm", "md", "lg", "xl", "2xl", "3xl"];
    }
  },

  actions: {
    increaseFontSize() {
      const size = this.fontSizes[this.fontSizes.indexOf(this.fontSize) + 1];
      if (size) this.fontSize = size;
    },

    decreaseFontSize() {
      const size = this.fontSizes[this.fontSizes.indexOf(this.fontSize) - 1];
      if (size) this.fontSize = size;
    },

    reset() {},
  },
});
