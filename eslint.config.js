// Code checks for the frontend. Run with: npm run lint
import js from "@eslint/js";
import globals from "globals";
import vue from "eslint-plugin-vue";

export default [
    js.configs.recommended,
    ...vue.configs["flat/essential"],
    {
        files: ["resources/js/**/*.{js,vue}"],
        languageOptions: { globals: globals.browser },
        rules: {
            // Page files here are named after their screen (Login, Users, ...).
            "vue/multi-word-component-names": "off",
            // Vuetify tables use slots with a dot, like v-slot:item.actions.
            "vue/valid-v-slot": ["error", { allowModifiers: true }],
        },
    },
    {
        files: ["public/sw.js"],
        languageOptions: { globals: globals.serviceworker },
    },
];
