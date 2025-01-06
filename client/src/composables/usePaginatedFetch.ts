import LinkHeader from "http-link-header";
import { computed, ref, shallowRef } from "vue";
import { useFetch, type UseFetchOptionsWithParams } from "./useFetch";

import type { RefresherCustomEvent } from "@ionic/vue";

export default function usePaginatedFetch<T>(
  startUrl: string,
  fetchOptions: UseFetchOptionsWithParams = {},
) {
  const url = ref(startUrl);

  const isPaginating = ref(true);
  const fetch = useFetch<T | T[]>(url, { ...fetchOptions, immediate: false }).get().json();
  const items = shallowRef<T[]>([]);

  const isEmpty = computed(() => {
    return fetch.isFinished.value && !fetch.error.value && items.value.length === 0;
  });

  fetch.onFetchResponse((response) => {
    if (fetch.data.value) {
      items.value = items.value.concat(fetch.data.value);
    }

    const links = LinkHeader.parse(response.headers.get("Link") ?? "");
    if (links.has("rel", "next")) {
      url.value = links.get("rel", "next")[0].uri;
    } else {
      isPaginating.value = false;
    }
  });

  // Load the next page
  async function load(event?: RefresherCustomEvent) {
    if (!isPaginating.value) return;
    await fetch.execute(true /* throw error */);
    event?.detail.complete();
  }

  async function reload(event?: RefresherCustomEvent) {
    // Clear previously loaded
    items.value = [];

    // Reset url
    url.value = startUrl;

    await load(event);
  }

  if (fetchOptions.immediate !== false) {
    load();
  }

  return { ...fetch, load, reload, items, isPaginating, isEmpty };
}
