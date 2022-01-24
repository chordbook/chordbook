import axios from 'axios'

export default axios.create({
  baseURL: import.meta.env.API_URL || 'https://chordbook.app',
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  }
})
