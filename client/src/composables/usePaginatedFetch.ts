import LinkHeader from "http-link-header";
import { computed, reactive, ref } from "vue";
import { useFetch } from "./useFetch";

import type { UseFetchOptionsWithParams, UseFetchReturn } from "./useFetch";

export default function usePaginatedFetch<T = unknown>(
  url: string,
  fetchOptions: UseFetchOptionsWithParams = {},
) {
  const nextUrl = ref<string | null>(url);
  const pages = reactive<UseFetchReturn<T>[]>([]);
  const isFetching = computed(() => pages.some((page) => page.isFetching));
  const isEmpty = computed(() => {
    const { isFinished, error } = pages[0];
    return isFinished && !error && items.value.length === 0;
  });
  const isPaginating = computed(() => !!nextUrl.value);
  const items = computed(() => pages.map(({ data }) => data!).filter(Boolean).flat())

  // Load the next page
  async function load(reload = false) {
    if (nextUrl.value === null) return;

    if (reload) {
      // Clear previous pages
      pages.splice(0);
    }

    const page = useFetch(nextUrl.value, { ...fetchOptions }).get().json();

    page.onFetchResponse(() => {
      const links = LinkHeader.parse(page.response.value?.headers.get("Link") ?? "");
      if (links.has("rel", "next")) {
        nextUrl.value = links.get("rel", "next")[0].uri;
      } else {
        nextUrl.value = null;
      }
    });

    pages.push(reactive(page));

    // Explicitly fetch if immediate is set to false
    if (fetchOptions.immediate === false) {
      page.execute(true /* throw error */);
    }

    return await page;
  }

  async function reload() {
    nextUrl.value = url;
    await load(true); // reload
  }

  return { load, reload, items, pages, isFetching, isEmpty, isPaginating };
}
