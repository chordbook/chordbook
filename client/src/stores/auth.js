import { defineStore } from 'pinia'
import { useFetch } from '@/client'
import { useStorage } from '@vueuse/core'
import { unref, computed, reactive, watch } from 'vue'
import { useRouter } from 'vue-router'
import console from '@/console'

export default defineStore('auth', () => {
  // Accepting the security trade-offs of persisting in localStorage. There is no other reasonable
  // method to keep the user signed across page reloads and multiple browser tabs. The access token
  // expiry is short and the refresh token is rotated every time it is used, so risk is reduced.
  // If anyone knows a better way to persist this securely, please share it.
  const user = useStorage('user', {})
  const accessToken = useStorage('accessToken', null)
  const expireAt = useStorage('expireAt', new Date())
  const refreshToken = useStorage('refreshToken', null)
  const isAuthenticated = computed(() => !!user.value.id)

  const refreshPayload = computed(() => ({ refresh_token: refreshToken.value }))
  const refreshFetch = reactive(useFetch('authenticate', { credentials: 'omit' }, {
    immediate: false,
    afterFetch: authenticated,
    onFetchError: reset
  }).put(refreshPayload).json())

  function signUp (data, useFetchOptions = {}) {
    const fetch = useFetch('users', useFetchOptions).post(data).json()
    fetch.onFetchResponse(() => authenticated(fetch))
    return fetch
  }

  function signIn (data, useFetchOptions = {}) {
    const fetch = useFetch('authenticate', useFetchOptions).post(data).json()
    fetch.onFetchResponse(() => authenticated(fetch))
    return fetch
  }

  function forgotPassword (data, useFetchOptions = {}) {
    return useFetch('password', useFetchOptions).post(data).json()
  }

  function resetPassword (data, useFetchOptions = {}) {
    return useFetch('password', useFetchOptions).put(data).json()
  }

  function signOut () {
    return useFetch('authenticate', { beforeFetch: reset }).delete()
  }

  function needsRefresh () {
    return expireAt.value - new Date() < 1000 // 1 second grace period
  }

  function refresh () {
    if (!refreshFetch.isFetching && refreshToken.value) {
      console.log('auth: refreshing token')
      refreshFetch.execute(true)
    }

    return refreshFetch
  }

  function reset () {
    user.value = {}
    accessToken.value = null
    refreshToken.value = null
    expireAt.value = new Date()

    console.debug('auth: reset')
  }

  function authenticated ({ data, response }) {
    accessToken.value = unref(response).headers.get('access-token')
    expireAt.value = new Date(unref(response).headers.get('expire-at') * 1000)
    refreshToken.value = unref(response).headers.get('refresh-token')
    user.value = unref(data)

    console.debug('auth: authenticated', unref(data))
  }

  async function beforeFetch ({ url, options }) {
    if (options.credentials !== 'omit' && accessToken.value) {
      if (needsRefresh()) {
        console.debug('auth: token is expired, refreshing before fetch', { url, options })
        await refresh()
      }

      console.debug('auth: adding credentials to request', { url, options, expireAt: expireAt.value })
      options.credentials = 'include'
      options.headers = {
        Authorization: `Bearer ${accessToken.value}`,
        ...options.headers
      }

      return { options }
    }
  }

  function handleExpiredToken (fetch) {
    if (refreshToken.value && fetch.statusCode.value === 401) {
      console.warn('auth: token is invalid, trying to refresh')
      refresh().then(() => {
        console.info('auth: token refreshed, retrying', fetch.response.value.url)
        fetch.execute()
      })
    }
  }

  const router = useRouter()

  function assert () {
    if (isAuthenticated.value) return true

    router.push('#signup')
    return false
  }

  function guard (callback) {
    return () => assert() && callback()
  }

  // Abort refresh if refreshed from another tab
  watch(refreshToken, () => refreshFetch.isFetching && refreshFetch.abort())

  return { beforeFetch, handleExpiredToken, user, isAuthenticated, signUp, signIn, signOut, forgotPassword, resetPassword, refresh, assert, guard }
})
