import useAuthStore from "@/stores/auth";
import { createFetch, useEventListener, useTimeoutFn, type UseFetchOptions, type UseFetchReturn } from "@vueuse/core";
import { computed, toValue, type MaybeRefOrGetter } from "vue";

export type { UseFetchReturn } from "@vueuse/core";
export type Params = Record<string, string>;
export type UseFetchOptionsWithParams = UseFetchOptions & {
  options?: RequestInit;
  params?: MaybeRefOrGetter<Params>;
};

const BASE_URL = import.meta.env.APP_API_URL || "https://api.chordbook.app/";

// Prefix URL with base and add query parameters
function buildUrl(url: MaybeRefOrGetter<string>, params?: MaybeRefOrGetter<Params>) {
  return computed(() => {
    // The existing useFetch implementation for baseUrl does naive string
    // concatenation instead of proper URL joining.
    const newUrl = new URL(toValue(url), BASE_URL);

    // Add support for query parameters to default useFetch implementation
    if (params) {
      for (const [key, val] of new URLSearchParams(toValue(params))) {
        newUrl.searchParams.append(key, val);
      }
    }

    return newUrl.toString();
  });
}

export const doFetch = createFetch({
  options: {
    beforeFetch(context) {
      return useAuthStore().beforeFetch(context);
    },
  },
  fetchOptions: {
    headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
    },
  },
});

export function useFetch<T = unknown>(
  url: MaybeRefOrGetter<string>,
  { options, params, ...useFetchOptions }: UseFetchOptionsWithParams = {},
): UseFetchReturn<T> & PromiseLike<UseFetchReturn<T>> {
  const fullUrl = buildUrl(url, params);

  // useFetch from @vueuse/core has a very complicated method signature. Try to simplify it by accepting
  // `options: RequestInit` as a property of `UseFetchOptionsWithParams` instead of an optional second argument.
  const fetch = doFetch<T>(
    fullUrl,
    options || {},
    useFetchOptions,
  ).json();

  fetch.onFetchResponse(() => {
    // Listen for workbox-broadcast-update updates form the service worker that match this request
    const unregister = useEventListener(navigator.serviceWorker, 'message', async (event: MessageEvent) => {
      if (event.data.meta !== 'workbox-broadcast-update') return;

      const { cacheName, updatedURL } = event.data.payload;

      const requestedUrl = fetch.response.value?.url;

      if (!requestedUrl || updatedURL !== requestedUrl) return;

      const cache = await caches.open(cacheName);
      const response = await cache.match(requestedUrl, { ignoreVary: true });

      if (response) {
        fetch.response.value = response;
        // useFetch should just update all these when setting response, but it's not internally reactive
        fetch.statusCode.value = response.status;
        fetch.data.value = await response.json();
      }
    });

    // Unregister listener after 30 seconds
    useTimeoutFn(unregister, 30 * 1000);
  })

  // Check for expired token on errors, which will refresh the token and re-execute
  fetch.onFetchError(() => useAuthStore().handleExpiredToken(fetch));

  return fetch;
}
