import { defineStore } from 'pinia'
import { ref, watch, unref } from 'vue'
import { useFetch } from '@/client'
import useAuthStore from '@/stores/auth'

export default (uid) => {
  return defineStore(`Library:${uid}`, () => {
    const auth = useAuthStore()
    const exists = ref(false)

    watch(
      () => auth.isAuthenticated,
      () => {
        if (!auth.isAuthenticated) return
        useFetch('library', { params: { uid } }).then(({ statusCode }) => {
          exists.value = unref(statusCode) === 200
        })
      },
      { immediate: true }
    )

    const add = auth.guard(() => {
      return useFetch('library').post({ uid }).then(async () => {
        exists.value = true
      })
    })

    const remove = auth.guard(() => {
      return useFetch('library').delete({ uid }).then(() => {
        exists.value = false
      })
    })

    return { exists, add, remove }
  })()
}
