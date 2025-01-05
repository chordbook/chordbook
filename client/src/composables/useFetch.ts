import useAuthStore from "@/stores/auth";
import { createFetch } from "@vueuse/core";
import { computed, toValue } from "vue";

import type { UseFetchOptions } from "@vueuse/core";
import type { MaybeRefOrGetter } from "vue";

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

export function useFetch<T>(
  url: MaybeRefOrGetter<string>,
  { options, params, ...useFetchOptions }: UseFetchOptionsWithParams = {},
) {
  const fullUrl = buildUrl(url, params);

  // useFetch from @vueuse/core has a very complicated method signature. Try to simplify it by accepting
  // `options: RequestInit` as a property of `UseFetchOptionsWithParams` instead of an optional second argument.
  const fetch = doFetch<T>(
    fullUrl,
    options || ({} as RequestInit),
    useFetchOptions as UseFetchOptions,
  );

  // Check for expired token on errors, which will refresh the token and re-execute
  fetch.onFetchError(() => useAuthStore().handleExpiredToken(fetch));

  return fetch;
}
