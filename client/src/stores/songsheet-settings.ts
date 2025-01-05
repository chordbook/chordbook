import { Instrument } from "@/ChordData";
import { useStorage } from "@vueuse/core";
import { defineStore } from "pinia";

export default defineStore("SongsheetSettings", {
  state: () => ({
    autoScroll: useStorage("autoScroll", false),
    instrument: useStorage<Instrument>("instrument", Instrument.Guitar),
    showChords: useStorage("showChords", false),
    columns: useStorage("columns", 1),
    showPlayer: useStorage("showPlayer", true),
  }),
});
