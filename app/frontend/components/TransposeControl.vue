<template>
  <ion-toolbar>
    <ion-buttons slot="start">
      <ion-button
        fill="clear"
        @click="value = 0"
      >
        <ion-icon
          slot="icon-only"
          :icon="icons.refresh"
          size="small"
        />
      </ion-button>

      <ion-button
        slot="start"
        fill="clear"
        @click="transposeDown"
      >
        <ion-icon
          slot="icon-only"
          :icon="icons.arrowDown"
        />
      </ion-button>
    </ion-buttons>

    <ion-select
      v-model="value"
      interface="action-sheet"
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
      slot="end"
      fill="clear"
      @click="transposeUp"
    >
      <ion-icon
        slot="icon-only"
        :icon="icons.arrowUp"
      />
    </ion-button>
  </ion-toolbar>
</template>

<script>
import { Chord } from 'chordsheetjs'
import { IonToolbar, IonButtons, IonButton, IonIcon, IonSelect, IonSelectOption } from '@ionic/vue'
import { arrowDown, arrowUp, refresh } from 'ionicons/icons'

export default {
  components: { IonToolbar, IonButtons, IonButton, IonIcon, IonSelect, IonSelectOption },

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
