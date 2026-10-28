import axios from 'axios'

const api = axios.create({
  baseURL: '/',              
  withCredentials: true,     
  headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'Accept': 'application/json',
  },
})

// Broadcast coarse connectivity signals so the shell's OfflineBar can react
// to unreachable-server failures (no response) even while the browser still
// claims to be online — captive portals and office DHCP are common here.
api.interceptors.response.use(
  (response) => {
    if (typeof window !== 'undefined') window.dispatchEvent(new Event('api:network-ok'))
    return response
  },
  (error) => {
    if (!error?.response && typeof window !== 'undefined') {
      window.dispatchEvent(new Event('api:network-error'))
    }
    return Promise.reject(error)
  },
)

export function useApi() {
  async function csrf() {
    await api.get('/sanctum/csrf-cookie')
  }

  return { api, csrf }
}
