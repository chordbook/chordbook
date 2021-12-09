<template>
  <div
    :class="'note mx-5 text-6xl font-bold relative inline-block ' + (active ? 'text-green-500' : '')"
    @click="select"
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

  emits: ['select'],

  watch: {
    active: 'activate'
  },

  mounted () {
    this.activate()
  },

  methods: {
    activate () {
      if (!this.active) return
      const parent = this.$el.parentElement
      parent.scrollLeft = this.$el.offsetLeft - (parent.clientWidth - (this.$el.clientWidth / 2)) / 2
    },

    select () {
      this.$emit('select', this.$data)
    }
  }
}
</script>
