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
            primary: '#7C3AED',
            secondary: '#5B6770',
            accent: '#C4B5FD',
            error: '#FF5252',
            info: '#7C3AED',
            success: '#4CAF50',
            warning: '#FFB300',
            background: '#F2F5F9',
            surface: '#FFFFFF',
          },
        },
        pixivDark: {
          dark: true,
          colors: {
            primary: '#A78BFA',
            secondary: '#9AA4B2',
            accent: '#C4B5FD',
            error: '#FF8A80',
            info: '#A78BFA',
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