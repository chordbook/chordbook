import axios from 'axios'
import { createFetch } from '@vueuse/core'

// DEPRECATED
export default axios.create({
  baseURL: import.meta.env.APP_API_URL || 'https://chordbook.app',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  }
})

export const useFetch = createFetch({
  baseUrl: new URL(import.meta.env.APP_API_URL || 'https://chordbook.app/', window.location).toString(),
  fetchOptions: {
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    }
  }
})
