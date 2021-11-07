/* eslint-env serviceworker */
import { precacheAndRoute } from 'workbox-precaching'
import { registerRoute } from 'workbox-routing';
import { CacheFirst, NetworkFirst } from 'workbox-strategies';
import { ExpirationPlugin } from 'workbox-expiration';

registerRoute(
  ({request}) => request.destination === 'script' || request.destination === 'style',
  new CacheFirst()
);

registerRoute(
  ({url, request}) => url.origin === self.location.origin && request.destination === 'document',
  new NetworkFirst({
    networkTimeoutSeconds: 3,
    cacheName: 'documents',
    plugins: [
      new ExpirationPlugin({ maxEntries: 500 }),
    ],
  })
);

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') self.skipWaiting()
})

// self.__WB_MANIFEST is default injection point
precacheAndRoute(self.__WB_MANIFEST)
