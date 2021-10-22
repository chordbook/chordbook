/* eslint-env serviceworker */

const CACHE_VERSION = 4
const CACHES = {
  prefetch: 'prefetch-cache-v' + CACHE_VERSION,
  readthrough: 'read-through-cache-v' + CACHE_VERSION
}

self.addEventListener('install', async event => {
  event.waitUntil(
    caches.open(CACHES.prefetch).then(async cache => {
      const urlsToPrefetch = await fetch('/offline.json').then(response => response.json())

      return cache.addAll(urlsToPrefetch).then(() => {
        console.log('Pre-fetching complete.')
        self.skipWaiting()
      })
    }).catch(function (error) {
      console.error('Pre-fetching failed:', error)
    })
  )
})

self.addEventListener('activate', event => {
  clients.claim()

  // Delete all old caches
  event.waitUntil(caches.keys().then(cacheNames => {
    return Promise.all(
      cacheNames.filter(cacheName => !Object.values(CACHES).includes(cacheName))
        .map(cacheName => {
          console.log('Deleting out of date cache:', cacheName)
          return caches.delete(cacheName)
        })
    )
  }))
})

self.addEventListener('fetch', event => {
  const response = (navigator.onLine ? requestFromNetwork(event) : Promise.reject(new Error('Offline')))
    .then(response => {
      event.waitUntil(cacheResponse(event, response.clone()))
      return response
    })
    .catch(() => requestFromCache(event))

  event.respondWith(response)
})

async function withTimeout (fn, delay = 3000) {
  const controller = new AbortController()
  const id = setTimeout(() => controller.abort(), delay)

  const result = await fn(controller.signal)
  clearTimeout(id)
  return result
}

function requestFromNetwork (event, timeout = 1000) {
  return withTimeout(signal => fetch(event.request, { signal }), timeout)
}

async function requestFromCache (event) {
  const response = await caches.match(event.request.url)
  return response || Promise.reject(new Error(`Not cached: ${event.request.url}`))
}

async function cacheResponse (event, response) {
  if (event.request.method === 'GET' && response.status < 400 && response.type === 'basic') {
    const cache = await caches.open(CACHES.readthrough)
    await cache.put(event.request, response)
  }

  return response
}
