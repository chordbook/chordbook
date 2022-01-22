<template>
  <div class="h-full flex flex-col overflow-hidden">
    <div class="dark:border-gray-900 bg-gray-100 py-3 text-gray-500 dark:bg-slate-900 shadow-md">
      <div class="max-w-8xl mx-auto px-4 md:px-6">
        <div class="grid grid-flow-col auto-cols-max divide-x dark:divide-gray-500 items-center">
          <div class="pr-3">
            <div class="flex">
              <div
                class="toggle"
                tooltip="Scroll vertically"
                tooltip-pos="bottom"
              >
                <input
                  id="settings-columns-1"
                  v-model="columns"
                  type="radio"
                  name="columns"
                  :value="1"
                >
                <label for="settings-columns-1">
                  <icon-bi:file />
                </label>
              </div>
              <div
                class="toggle"
                tooltip="Scroll horizontally"
                tooltip-pos="bottom"
              >
                <input
                  id="settings-columns-2"
                  v-model="columns"
                  type="radio"
                  name="columns"
                  :value="2"
                >
                <label for="settings-columns-2">
                  <icon-bi:layout-three-columns />
                </label>
              </div>
            </div>
          </div>

          <div class="px-3">
            <div class="flex items-center">
              <button
                class="flex"
                tooltip="Transpose down"
                tooltip-pos="bottom"
                @click="transposeDown"
              >
                <icon-bi:arrow-down class="icon-small" />
              </button>
              <select
                v-model="transpose"
                class="mx-1 py-1 pl-2 pr-6 btn btn-muted font-normal normal-case"
              >
                <template
                  v-for="note in transpositions"
                  :key="note.step"
                >
                  <option
                    v-if="note.step === 0"
                    disabled
                  >
                    -
                  </option>
                  <option :value="note.step">
                    {{ note.name }}
                  </option>
                  <option
                    v-if="note.step === 0"
                    disabled
                  >
                    -
                  </option>
                </template>
              </select>
              <button
                class="flex"
                tooltip="Transpose up"
                tooltip-pos="bottom"
                @click="transposeUp"
              >
                <icon-bi:arrow-up class="icon-small" />
              </button>
            </div>
          </div>

          <div class="px-3">
            <div
              class="toggle"
              tooltip="Show Chords"
              tooltip-pos="bottom"
            >
              <input
                id="settings-chord-diagram"
                v-model="showChords"
                type="checkbox"
              >
              <label for="settings-chord-diagram">
                <icon-app-chord-diagram />
              </label>
            </div>
          </div>

          <div class="px-3">
            <button
              class="toggle"
              tooltip="Tuner"
              tooltip-pos="bottom"
              @click="toggleTuner"
            >
              <icon-app-tuning-fork />
            </button>

            <TransitionRoot
              :show="showTuner"
              enter="transition-opacity duration-75"
              enter-from="opacity-0"
              enter-to="opacity-100"
              leave="transition-opacity duration-150"
              leave-from="opacity-100"
              leave-to="opacity-0"
            >
              <Dialog
                class="fixed inset-0 z-10 overflow-y-auto"
                @close="toggleTuner"
              >
                <div class="flex items-center justify-center min-h-screen">
                  <DialogOverlay class="fixed inset-0 bg-black opacity-50" />

                  <div class="relative max-w-sm mx-auto border bg-white dark:bg-gray-800 dark:text-gray-200 dark:border-black rounded-md overflow-hidden drop-shadow-lg">
                    <tuner />
                  </div>
                </div>
              </Dialog>
            </TransitionRoot>
          </div>

          <div class="px-3">
            <router-link
              :to="{ name: 'songsheet.edit', params: { id: $route.params.id } }"
              class="btn btn-muted btn-small"
            >
              Edit
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <div class="grow overflow-hidden px-4">
      <song
        v-if="source"
        :source="source"
        :columns="columns"
        :show-chords="showChords ? 'last' : false"
        :transpose="transpose"
        @update:key="key = $event.value"
      />
    </div>
  </div>
</template>

<script>
import {
  Dialog,
  DialogOverlay,
  TransitionRoot
} from '@headlessui/vue'
import { Chord } from 'chordsheetjs'
import api from '~/client'

export default {
  components: { Dialog, DialogOverlay, TransitionRoot },

  beforeRouteEnter (to, from, next) {
    return api.get(`/api/songsheets/${to.params.id}.json`).then(response => {
      next(vm => (vm.source = response.data.source))
    }).catch(() => {
      next({ name: '404', replace: true })
    })
  },

  props: {
    edit: {
      type: String,
      default: null
    }
  },

  data () {
    return {
      showTuner: false,
      source: '',
      key: 'C',
      transpose: 0
    }
  },

  computed: {
    showChords: {
      get () { return this.$store.state.showChords },
      set (value) { this.$store.commit('update', { showChords: !!value }) }
    },

    columns: {
      get () { return this.$store.state.columns || 1 },
      set (value) { this.$store.commit('update', { columns: value }) }
    },

    transpositions () {
      if (!this.key) return

      const key = Chord.parse(this.key)
      const steps = []
      for (let i = -11; i <= 11; i++) {
        steps.push({ step: i, name: key.transpose(i) })
      }
      return steps
    }
  },

  watch: {
    transpose (newValue) {
      if (newValue > 11) {
        this.transpose = -11
      } else if (newValue < -11) {
        this.transpose = 11
      }
    }
  },

  methods: {
    toggleTuner () {
      this.showTuner = !this.showTuner
    },

    transposeUp () {
      this.transpose++
    },

    transposeDown () {
      this.transpose--
    }
  }
}
</script>
