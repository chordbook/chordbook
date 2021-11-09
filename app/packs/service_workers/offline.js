/* eslint-env serviceworker */
import { precacheAndRoute } from 'workbox-precaching'
import { registerRoute } from 'workbox-routing'
import { CacheFirst, NetworkFirst } from 'workbox-strategies'
import { ExpirationPlugin } from 'workbox-expiration'
import { CacheableResponsePlugin } from 'workbox-cacheable-response'

registerRoute(
  ({ request }) => request.destination === 'script' || request.destination === 'style',
  new CacheFirst()
)

// Loading pages (and turbolinks requests), checks the network first
registerRoute(
  ({ request }) => request.destination === 'document' || (
    request.destination === '' &&
    request.mode === 'cors' &&
    request.headers.get('Turbolinks-Referrer') !== null
  ),
  new NetworkFirst({
    networkTimeoutSeconds: 3,
    cacheName: 'documents',
    plugins: [
      new ExpirationPlugin({ maxEntries: 500 }),
      new CacheableResponsePlugin({
        statuses: [0, 200]
      })
    ]
  })
)

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') self.skipWaiting()
})

// self.__WB_MANIFEST is default injection point
precacheAndRoute(self.__WB_MANIFEST)
