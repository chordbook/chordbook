<template>
  <div
    class="meter"
    style="position:relative"
  >
    <div
      class="meter-pointer"
      :style="`left: ${left}`"
    />
  </div>
</template>

<script>
export default {
  props: {
    cents: {
      type: Number,
      required: true
    }
  },

  computed: {
    degrees () {
      return (this.cents / 50) * 45
    },

    transform () {
      return 'rotate(' + this.degrees + 'deg)'
    },

    left () {
      return (this.cents + 50) + '%'
    }
  },

  mounted () {
    for (let i = 0; i <= 10; i += 1) {
      const $scale = document.createElement('div')
      $scale.className = 'meter-scale'
      $scale.style.left = (i * 10) + '%'
      if (i % 5 === 0) {
        $scale.classList.add('meter-scale-strong')
      }
      this.$el.appendChild($scale)
    }
  }
}
</script>

<style>
.meter {
  position: relative;
  height: 25px;
}

.meter-pointer {
  z-index: 20;
  width: 4px;
  height: 20px;
  transform: translate(-50%); /* Center items */
  @apply bg-green-500;
  transition: left 1s;
  position: absolute;
  left: 50%;
}

.meter-scale {
  opacity: 0.5;
  width: 1px;
  margin-left:-0.5px;
  height: 100%;
  box-sizing: border-box;
  border-top: 10px solid;
  position: absolute;
  left: 50%;
}

.meter-scale-strong {
  width: 2px;
  border-top-width: 20px;
}
</style>
