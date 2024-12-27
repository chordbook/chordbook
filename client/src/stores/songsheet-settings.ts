import { defineStore } from "pinia";
import { useStorage } from "@vueuse/core";

export default defineStore("SongsheetSettings", {
  state: () => ({
    autoScroll: useStorage("autoScroll", false),
    instrument: useStorage("instrument", "guitar"),
    showChords: useStorage("showChords", false),
    columns: useStorage("columns", 1),
    showPlayer: useStorage("showPlayer", true),
  }),
});
