import axios from 'axios'

const api = axios.create({
  baseURL: '/',              
  withCredentials: true,     
  headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'Accept': 'application/json',
  },
})

export function useApi() {
  async function csrf() {
    await api.get('/sanctum/csrf-cookie')
  }

  return { api, csrf }
}
