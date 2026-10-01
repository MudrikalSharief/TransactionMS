import { defineConfig } from 'vite'
import laravel from 'laravel-vite-plugin'
import vue from '@vitejs/plugin-vue'
import vuetify from 'vite-plugin-vuetify'
import path from 'path'

export default defineConfig({
  plugins: [
    laravel({
      input: ['resources/css/app.css', 'resources/js/app.js'],
      refresh: true,
    }),
    vue(),
    // Tree-shakes Vuetify: only components/directives actually used in
    // templates ship JS + per-component Sass, instead of the full library
    // (was: 848KB CSS + whole framework on every load).
    vuetify({ autoImport: true }),
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'resources/js'),
    },
  },
  build: {
    // Low-end / bad-network tuning (no DB or icon changes):
    // - split vendor chunks so route chunks stay small and cache well
    // - keep single CSS entry (Vuetify) but allow async chunk CSS
    chunkSizeWarningLimit: 600,
    cssCodeSplit: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vue: ['vue', 'vue-router'],
          vuetify: ['vuetify'],
        },
      },
    },
  },
})
