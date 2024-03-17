<template>
  <div class="flex items-center">
    <div class="flex flex-auto">
      <ion-button
        fill="clear"
        @click="transposeDown"
      >
        <ion-icon
          slot="icon-only"
          :icon="icons.arrowDown"
        />
      </ion-button>

      <ion-select
        aria-label="Key"
        v-model="value"
        class="text-center w-20 relative"
        cancel-text="Reset"
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
        fill="clear"
        @click="transposeUp"
      >
        <ion-icon
          slot="icon-only"
          :icon="icons.arrowUp"
        />
      </ion-button>
    </div>
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
