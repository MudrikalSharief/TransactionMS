// Full Vuetify styles + all components/directives: the app's layout is
// built on Vuetify utility classes (d-flex, align-center, text-caption,
// font-weight-bold, ...), which per-component tree-shaking does NOT ship.
// Keep the MDI font CSS (icon-font decision unchanged).
import 'vuetify/styles'
import '@mdi/font/css/materialdesignicons.css'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

import { aliases, mdi } from 'vuetify/iconsets/mdi'
import {
  mdiAccount,
  mdiLogout,
  mdiLogin,
  mdiPencil,
  mdiDelete,
  mdiFormTextbox,
  mdiClipboardCheckOutline,
} from '@mdi/js'

export function createVuetifyInstance() {
  return createVuetify({
    components,
    directives,
    // Switches: a clear "on" colour everywhere (green track vs grey when
    // off) and the rounded inset style. Without a colour, on and off drew
    // the same grey track, so toggles looked like they did nothing.
    defaults: {
      VSwitch: { color: 'success', inset: true },
    },
    icons: {
      defaultSet: 'mdi',
      aliases: {
        ...aliases,
        account: mdiAccount,
        logout: mdiLogout,
        login: mdiLogin,

        edit: mdiPencil,
        delete: mdiDelete,
        fields: mdiFormTextbox,
        requirements: mdiClipboardCheckOutline,
      },
      sets: { mdi },
    },
    theme: {
      defaultTheme: 'pixivLight',
      themes: {
        pixivLight: {
          dark: false,
          colors: {
            primary: '#16307C',
            secondary: '#5B6770',
            accent: '#93C5FD',
            error: '#FF5252',
            info: '#16307C',
            success: '#4CAF50',
            warning: '#FFB300',
            background: '#F2F5F9',
            surface: '#FFFFFF',
          },
        },
        pixivDark: {
          dark: true,
          colors: {
            primary: '#93C5FD',
            secondary: '#9AA4B2',
            accent: '#93C5FD',
            error: '#FF8A80',
            info: '#93C5FD',
            success: '#66BB6A',
            warning: '#FFCA28',
            background: '#12121A',
            surface: '#1E1E2E',
          },
        },
      },
    },
  })
}