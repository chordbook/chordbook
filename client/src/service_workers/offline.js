/* eslint-env serviceworker */
import { precacheAndRoute } from 'workbox-precaching'
import { registerRoute } from 'workbox-routing'
import { CacheFirst, NetworkFirst } from 'workbox-strategies'
import { ExpirationPlugin } from 'workbox-expiration'
import { CacheableResponsePlugin } from 'workbox-cacheable-response'
import { clientsClaim } from 'workbox-core'

registerRoute(
  ({ request }) => ['script', 'style', 'image'].includes(request.destination),
  new CacheFirst()
)

// Loading pages, checks the network first
registerRoute(
  ({ request }) => request.destination === 'document' || (
    request.destination === '' &&
    request.mode === 'cors'
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

self.skipWaiting()
clientsClaim()

// self.__WB_MANIFEST is default injection point
precacheAndRoute(self.__WB_MANIFEST)
