import { useFetch } from '@/client'
import { computed } from 'vue'

export function useFlipper (feature, initialData = { enabled: false }) {
  const { data } = useFetch(`flipper/${feature}`, { initialData }).get().json()

  return {
    isEnabled: computed(() => data.value.enabled)
  }
}
