<template>
  <div class="toggle">
    <input ref="input" id="settings-wakelock" type="checkbox" v-model="enabled">
    <label for="settings-wakelock">
      <icon name="brightness-high"/>
    </label>
  </div>
</template>

<script>
import NoSleep from 'nosleep.js'

const noSleep = new NoSleep()

export default {
  data() {
    return {
      enabled: noSleep.enabled
    }
  },

  watch: {
    enabled(newValue, oldValue) {
      newValue ? noSleep.enable() : noSleep.disable()
    }
  }
}
</script>
