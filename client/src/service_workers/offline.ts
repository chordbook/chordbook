/* eslint-env serviceworker */
import { BackgroundSyncPlugin } from "workbox-background-sync";
import { CacheableResponsePlugin } from "workbox-cacheable-response";
import { clientsClaim } from "workbox-core";
import { ExpirationPlugin } from "workbox-expiration";
import { createHandlerBoundToURL, precacheAndRoute } from "workbox-precaching";
import { NavigationRoute, registerRoute } from "workbox-routing";
import { CacheFirst, NetworkFirst } from "workbox-strategies";

declare let self: ServiceWorkerGlobalScope;

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
