import { createApp } from 'vue'
import { createRouter } from '@/router'
import { createVuetifyInstance } from '@/plugins/vuetify'
import AppShell from '@/components/AppShell.vue'

const app = createApp(AppShell)

app.use(createRouter())
app.use(createVuetifyInstance())

app.mount('#app')

// Instant repeat loads: cache-first service worker for hashed build assets,
// static images, and fonts. Prod only (dev must always stay fresh), fire and
// forget — registration never blocks paint and failures are swallowed.
if ('serviceWorker' in navigator && import.meta.env.PROD) {
  const idle = window.requestIdleCallback?.bind(window) ?? ((fn) => setTimeout(fn, 3000))
  idle(() => {
    navigator.serviceWorker.register('/sw.js').catch(() => {})
  })
}
