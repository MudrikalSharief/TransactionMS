import { defineConfig } from 'vite'
import laravel, { refreshPaths } from 'laravel-vite-plugin'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [
    laravel({
      input: ['resources/css/app.css', 'resources/js/app.js'],
      // Dev server: reload the page when backend code changes too, so API
      // changes (controllers, models) show up without a manual refresh.
      refresh: [...refreshPaths, 'app/Http/**', 'app/Models/**'],
    }),
    vue(),
  ],
  server: {
    // graphify's generated graph.html is not part of the app; changes to it
    // must not reload the page.
    watch: { ignored: ['**/graphify-out/**'] },
  },
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
