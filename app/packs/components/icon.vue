<template>
  <svg :class="classNames" xmlns="http://www.w3.org/2000/svg" role="image">
    <use :xlink:href="href"></use>
  </svg>
</template>

<script>
export default {
  props: {
    name: String,
    class: String
  },

  computed: {
    href() {
      return `/packs/spritemap.svg#sprite-` + this.name
    },

    classNames() {
      return ['icon', this.class].filter(Boolean).join(' ')
    }
  }
}
</script>
