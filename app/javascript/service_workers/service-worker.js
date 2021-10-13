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
  event.waitUntil(caches.keys().then(async cacheNames => {
    return Promise.all(cacheNames.map(cacheName => {
      if (!Object.values(CACHES).includes(cacheName)) {
        console.log('Deleting out of date cache:', cacheName)
        return caches.delete(cacheName)
      } else {
        return Promise.resolve()
      }
    }))
  }))
})

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request.url).then(async response => {
      // Return cached response
      if (response) {
        console.log('Found response in cache:', response)
        return response
      }

      // No response found in cache, fetch from network
      return fetch(event.request).then(async response => {
        if (response.status < 400 && event.request.type === 'basic') {
          console.log('Caching response from network:', response)

          // Cache response
          const cache = await caches.open(CACHES.readthrough)
          cache.put(event.request, response.clone())
        }

        return response
      })
    })
  )
})
