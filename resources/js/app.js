import { createApp } from 'vue'
import { createRouter } from '@/router'
import { createVuetifyInstance } from '@/plugins/vuetify'
import AppShell from '@/components/AppShell.vue'

const app = createApp(AppShell)

app.use(createRouter())
app.use(createVuetifyInstance())

app.mount('#app')
