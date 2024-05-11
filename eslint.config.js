import js from "@eslint/js";
import globals from "globals";
import prettier from "eslint-config-prettier";
import vue from "eslint-plugin-vue";

export default [
  {
    ignores: ["public/"],
  },
  js.configs.recommended,
  ...vue.configs["flat/recommended"],
  prettier,
  {
    ignores: ["client/"],
    languageOptions: { globals: globals.node },
  },
  {
    files: ["client/**/*.{js,vue}"],
    languageOptions: { globals: globals.browser },
    rules: {
      "vue/multi-word-component-names": 0,
      "vue/first-attribute-linebreak": 0,
      // https://ionicframework.com/docs/vue/troubleshooting#slot-attributes-are-deprecated
      "vue/no-deprecated-slot-attribute": "off",
    },
  },
];
