module.exports = {
  extends: [
    'standard',
    'plugin:vue/vue3-recommended'
  ],
  rules: {
    'vue/multi-word-component-names': 0,
    // https://ionicframework.com/docs/vue/troubleshooting#slot-attributes-are-deprecated
    'vue/no-deprecated-slot-attribute': 'off'
  }
}
