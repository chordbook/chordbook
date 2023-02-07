<template>
  <div
    class="note mx-8 text-6xl font-bold relative inline-block transition[color] duration-200"
  >
    {{ name[0] }}
    <span class="absolute font-normal note-sharp text-3xl top-0">{{ name[1] || '' }}</span>
    <span class="absolute font-normal text-lg opacity-70 bottom-0">{{ octave }}</span>
  </div>
</template>

<script>
export default {
  props: {
    active: Boolean,
    name: {
      type: String,
      required: true
    },
    octave: {
      type: String,
      required: true
    },
    frequency: {
      type: Number,
      required: true
    }
  },

  watch: {
    active: 'activate'
  },

  mounted () {
    setTimeout(() => this.activate('auto'), 10)
  },

  methods: {
    activate () {
      if (!this.active) return
      this.$el.scrollIntoView({ inline: 'center' })
    }
  }
}
</script>
