/* eslint-env serviceworker */

const CACHE_VERSION = 3
const CACHES = {
  prefetch: 'prefetch-cache-v' + CACHE_VERSION,
  readthrough: 'read-through-cache-v' + CACHE_VERSION
}

self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(CACHES.prefetch).then(async (cache) => {
      const urlsToPrefetch = await fetch('/offline.json').then(response => response.json())

      const cachePromises = urlsToPrefetch.map(function (urlToPrefetch) {
        const url = new URL(urlToPrefetch, location.href)
        const request = new Request(url, { mode: 'no-cors' })

        return fetch(request).then(function (response) {
          if (response.status >= 400) {
            throw new Error(`request for ${urlToPrefetch} failed:`, response.statusText)
          }

          return cache.put(request, response)
        }).catch(function (error) {
          console.error('Not caching ' + urlToPrefetch + ' due to ' + error)
        })
      })

      return Promise.all(cachePromises).then(function () {
        console.log('Pre-fetching complete.')
      })
    }).catch(function (error) {
      console.error('Pre-fetching failed:', error)
    })
  )
})

self.addEventListener('activate', function (event) {
  // Delete all old caches
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (!Object.values(CACHES).includes(cacheName)) {
            console.log('Deleting out of date cache:', cacheName)
            return caches.delete(cacheName)
          }

          return Promise.resolve()
        })
      )
    })
  )
})

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request.url).then(function (response) {
      // Return cached response
      if (response) {
        console.log('Found response in cache:', response)
        return response
      }

      // No response found in cache, fetch from network
      return fetch(event.request).then(function (response) {
        if (response.status < 400 && event.request.type === 'basic') {
          console.log('Caching response from network:', response)

          // Cache response
          caches.open(CACHES.readthrough).then(function (cache) {
            return cache.put(event.request, response.clone())
          })
        }

        return response
      })
    })
  )
})
