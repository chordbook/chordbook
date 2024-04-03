<template>
  <div class="flex align-center">
    <ion-button
      v-tooltip="'Transpose down'"
      class="text-2xl"
      @click="transposeDown"
    >
      ♭
    </ion-button>
    <ion-select
      v-model="value"
      v-tooltip="'Key'"
      aria-label="Key"
      cancel-text="Reset"
      justify="center"
      :interface-options="{ header: 'Key…' }"
      @ion-cancel="value = 0"
    >
      <ion-select-option
        v-for="n in transpositions"
        :key="n.step"
        :value="n.step"
      >
        {{ n.name }}
      </ion-select-option>
    </ion-select>
    <ion-button
      v-tooltip="'Transpose up'"
      class="text-2xl"
      @click="transposeUp"
    >
      ♯
    </ion-button>
  </div>
</template>

<script>
import { Chord } from 'chordsheetjs'
import { arrowDown, arrowUp, refresh } from 'ionicons/icons'

export default {
  props: {
    note: {
      type: String,
      required: true
    }
  },

  emits: ['update'],

  data () {
    return {
      value: 0,
      icons: { arrowDown, arrowUp, refresh }
    }
  },

  computed: {
    transpositions () {
      if (!this.note) return

      const key = Chord.parse(this.note)
      const steps = []
      for (let i = -11; i <= 11; i++) {
        steps.push({ step: i, name: key.transpose(i) })
      }
      return steps
    }
  },

  watch: {
    value (newValue) {
      if (newValue > 11) {
        this.value = -11
      } else if (newValue < -11) {
        this.value = 11
      }

      this.$emit('update', this.value)
    }
  },

  methods: {
    transposeUp () {
      this.value++
    },

    transposeDown () {
      this.value--
    }
  }
}
</script>

<style scoped>
ion-select::part(icon) {
  @apply hidden;
}

ion-select::part(text) {
  @apply w-10 inline-block text-center;
}
</style>
