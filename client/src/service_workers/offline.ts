/* eslint-env serviceworker */
import { precacheAndRoute, createHandlerBoundToURL } from "workbox-precaching";
import { registerRoute, NavigationRoute } from "workbox-routing";
import { CacheFirst, NetworkFirst } from "workbox-strategies";
import { ExpirationPlugin } from "workbox-expiration";
import { CacheableResponsePlugin } from "workbox-cacheable-response";
import { clientsClaim } from "workbox-core";
import { BackgroundSyncPlugin } from "workbox-background-sync";

declare let self: ServiceWorkerGlobalScope

// BUMP this to force clients to reload
const VERSION = "1";
console.log({ VERSION });

// Take over and reload clients when service worker updates
self.skipWaiting();
clientsClaim();

// Pre-cache all generated assets
precacheAndRoute(self.__WB_MANIFEST);

// Assets, checks the cache first
registerRoute(
  ({ request }) => ["script", "style", "image"].includes(request.destination),
  new CacheFirst({
    cacheName: "assets",
    plugins: [
      new ExpirationPlugin({ maxEntries: 1000 }),
      new CacheableResponsePlugin({ statuses: [0, 200] }),
      new BackgroundSyncPlugin("assets"),
    ],
  }),
);

// API requests, checks the network first
registerRoute(
  ({ request }) => request.destination === "" && request.mode === "cors",
  new NetworkFirst({
    networkTimeoutSeconds: 3,
    cacheName: "api",
    plugins: [
      new ExpirationPlugin({ maxEntries: 500 }),
      new CacheableResponsePlugin({ statuses: [0, 200] }),
      new BackgroundSyncPlugin("api"),
    ],
  }),
);

// Use / for all navigation requests that are not cached
registerRoute(new NavigationRoute(createHandlerBoundToURL("index.html")));
