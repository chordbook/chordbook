import { defineStore } from 'pinia'
import { useFetch } from '@/client'
import { useStorage } from '@vueuse/core'
import { ref, unref, computed, reactive, watchEffect } from 'vue'
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
  const ttl = computed(() => {
    // 5% random jitter to reduce likelihood of multiple tabs refreshing at same time
    const jitter = 1 - (Math.random() * 0.05)
    return (+expireAt.value - new Date()) * jitter
  })

  const refreshTimeout = ref(null)
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

  function beforeFetch ({ url, options }) {
    if (options.credentials !== 'omit' && accessToken.value) {
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
      console.warn('auth: token expired, trying to refresh')
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

  // Schedule refresh when token/ttl changes
  watchEffect(() => {
    console.debug('auth: setting timeout for refresh', {
      expireAt: expireAt.value,
      setTimeout: new Date(+new Date() + ttl.value)
    })
    clearTimeout(refreshTimeout.value)
    refreshTimeout.value = refreshToken.value && setTimeout(refresh, ttl.value)
  })

  return { beforeFetch, handleExpiredToken, user, isAuthenticated, signUp, signIn, signOut, forgotPassword, resetPassword, refresh, assert, guard }
})
