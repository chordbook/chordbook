/*
 Copyright 2014 Google Inc. All Rights Reserved.
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

var CACHE_VERSION = 2;
var CACHES = {
  prefetch: 'prefetch-cache-v' + CACHE_VERSION
};

self.addEventListener('install', function (event) {
  var now = Date.now();

  event.waitUntil(
    caches.open(CACHES.prefetch).then(async (cache) => {
      const urlsToPrefetch = await fetch('/offline.json').then(response => response.json())

      console.log('Prefetching URLs:', urlsToPrefetch)

      var cachePromises = urlsToPrefetch.map(function(urlToPrefetch) {
        var url = new URL(urlToPrefetch, location.href);
        // Append a prefetch=TIMESTAMP URL parameter to each URL's query string.
        // This is particularly important when precaching resources that are later used in the
        // fetch handler as responses directly, without consulting the network (i.e. cache-first).
        // If we were to get back a response from the HTTP browser cache for this precaching request
        // then that stale response would be used indefinitely, or at least until the next time
        // the service worker script changes triggering the install flow.
        url.search += (url.search ? '&' : '?') + 'prefetch=' + now;

        var request = new Request(url, {mode: 'no-cors'});

        return fetch(request).then(function(response) {
          if (response.status >= 400) {
            throw new Error(`request for ${urlToPrefetch} failed:`, response.statusText);
          }

          return cache.put(new URL(urlToPrefetch, location.href), response);
        }).catch(function(error) {
          console.error('Not caching ' + urlToPrefetch + ' due to ' + error);
        });
      });

      return Promise.all(cachePromises).then(function() {
        console.log('Pre-fetching complete.');
      });
    }).catch(function(error) {
      console.error('Pre-fetching failed:', error);
    })
  );
});

self.addEventListener('activate', function(event) {
  // Delete all old caches
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (!Object.values(CACHES).includes(cacheName)) {
            console.log('Deleting out of date cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

self.addEventListener('fetch', function(event) {
  console.log('Handling fetch event for', event.request);

  event.respondWith(
    // caches.match() will look for a cache entry in all of the caches available to the service worker.
    // It's an alternative to first opening a specific named cache and then matching on that.
    caches.match(event.request).then(function(response) {
      if (response) {
        console.log('Found response in cache:', response);

        return response;
      }

      console.log('No response found in cache. About to fetch from network...');

      // event.request will always have the proper mode set ('cors, 'no-cors', etc.) so we don't
      // have to hardcode 'no-cors' like we do when fetch()ing in the install handler.
      return fetch(event.request).then(function(response) {
        console.log('Response from network is:', response);

        return response;
      }).catch(function(error) {
        // This catch() will handle exceptions thrown from the fetch() operation.
        // Note that a HTTP error response (e.g. 404) will NOT trigger an exception.
        // It will return a normal response object that has the appropriate error code set.
        console.error('Fetching failed:', error);

        throw error;
      });
    })
  );
});
