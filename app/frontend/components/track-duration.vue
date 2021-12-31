<template>
  <div>
    {{ format }}
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: Number,
      required: true
    }
  },

  computed: {
    seconds () {
      return Math.round(this.value / 1000)
    },

    format () {
      return [
        Math.floor(this.seconds / 60),
        (this.seconds % 60).toString().padStart(2, '0')
      ].join(':')
    }
  }
}
</script>
