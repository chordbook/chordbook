<template>
  <div class="meter">
    <div class="meter-dot"></div>
    <div class="meter-pointer" :style="`transform: ${this.transform}`"></div>
  </div>
</template>

<script>
export default {
  props: {
    cents: Number
  },

  mounted () {
    for (let i = 0; i <= 10; i += 1) {
      const $scale = document.createElement('div')
      $scale.className = 'meter-scale'
      $scale.style.transform = 'rotate(' + (i * 9 - 45) + 'deg)'
      if (i % 5 === 0) {
        $scale.classList.add('meter-scale-strong')
      }
      this.$el.appendChild($scale)
    }
  },

  computed: {
    degrees () {
      return (this.cents / 50) * 45
    },

    transform () {
      return 'rotate(' + this.degrees + 'deg)'
    }
  }
}
</script>

<style>
.meter {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 50%;
  width: 400px;
  height: 33%;
  margin: 0 auto 5vh auto;
}

.meter-pointer {
  width: 2px;
  height: 100%;
  background: #2c3e50;
  transform: rotate(45deg);
  transform-origin: bottom;
  transition: transform 0.5s;
  position: absolute;
  right: 50%;
}

.meter-dot {
  width: 10px;
  height: 10px;
  background: #2c3e50;
  border-radius: 50%;
  position: absolute;
  bottom: -5px;
  right: 50%;
  margin-right: -4px;
}

.meter-scale {
  width: 1px;
  height: 100%;
  transform-origin: bottom;
  transition: transform 0.2s;
  box-sizing: border-box;
  border-top: 10px solid;
  position: absolute;
  right: 50%;
}

.meter-scale-strong {
  width: 2px;
  border-top-width: 20px;
}
</style>
