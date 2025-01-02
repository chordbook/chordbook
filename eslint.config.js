import pluginVitest from "@vitest/eslint-plugin";
import skipFormatting from "@vue/eslint-config-prettier/skip-formatting";
import vueTsEslintConfig from "@vue/eslint-config-typescript";
import pluginVue from "eslint-plugin-vue";
import globals from "globals";

export default [
  {
    name: "app/files-to-lint",
    files: ["client/**/*.{ts,mts,tsx,vue}"],
  },

  {
    name: "app/files-to-ignore",
    ignores: ["public/"],
  },

  ...pluginVue.configs["flat/essential"],
  ...vueTsEslintConfig(),

  {
    ...pluginVitest.configs.recommended,
    files: ["client/test/*"],
  },

  {
    files: ["client/**/*.{ts,js,vue}"],
    languageOptions: { globals: globals.browser },
    rules: {
      "vue/multi-word-component-names": 0,
      "vue/first-attribute-linebreak": 0,
      // https://ionicframework.com/docs/vue/troubleshooting#slot-attributes-are-deprecated
      "vue/no-deprecated-slot-attribute": "off",
    },
  },

  skipFormatting,
];
