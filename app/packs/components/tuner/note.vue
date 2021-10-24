<template>
  <div :class="'note' + (active ? ' active' : '')" @click="select">
    {{name[0]}}
    <span class="note-sharp">{{ name[1] || '' }}</span>
    <span class="note-octave">{{ octave }}</span>
  </div>
</template>

<script>
export default {
  props: {
    active: Boolean,
    name: String,
    octave: String,
    frequency: Number
  },

  mounted() {
    this.activate()
  },

  methods: {
    activate() {
      if(!this.active) return
      const parent = this.$el.parentElement
      parent.scrollLeft = this.$el.offsetLeft - (parent.clientWidth - this.$el.clientWidth) / 2
    },

    select() {
      this.$emit('select', this.$data)
    }
  },

  watch: {
    active: 'activate'
  }
}
</script>
