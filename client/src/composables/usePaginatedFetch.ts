import { useFetch } from "@/client";
import LinkHeader from "http-link-header";
import { computed, reactive, ref } from "vue";
import { useFetch } from "./useFetch";

import type { UseFetchOptionsWithParams, UseFetchReturn } from "./useFetch";

export default function usePaginatedFetch(
  url: string,
  fetchOptions: UseFetchOptionsWithParams = {},
) {
  const nextUrl = ref<string | null>(url);
  // FIXME: This should be UseFetchReturn<any>[], but the `pages.push(…)` below gives a bizarre error
  const pages = reactive<any[]>([]);
  const items = reactive<any[]>([]);
  const isFetching = computed(() => pages.some((page) => page.isFetching));
  const isEmpty = computed(() => {
    const page = pages[0];
    return page?.isFinished && !page.error && (page.data as any[]).length === 0;
  });
  const isPaginating = ref(false);

  // Load the next page
  function load(reload = false) {
    if (nextUrl.value === null) return;

    if (reload) {
      // Clear previous accumulator of items
      items.splice(0);

      // Clear previous pages
      pages.splice(-1);
    }

    const page = useFetch(nextUrl.value, { ...fetchOptions, immediate: false })
      .get()
      .json();

    page.onFetchResponse(() => {
      items.push(...Array.from(page.data.value));

      const links = LinkHeader.parse(page.response.value?.headers.get("Link") ?? "");
      if (links.has("rel", "next")) {
        nextUrl.value = links.get("rel", "next")[0].uri;
        isPaginating.value = true;
      } else {
        nextUrl.value = null;
        isPaginating.value = false;
      }
    });

    pages.push(page as UseFetchReturn<any>);

    if (fetchOptions.immediate !== false) {
      page.execute(true /* throw error */);
    }

    return page;
  }

  async function reload() {
    nextUrl.value = url;
    await load(true); // reload
  }

  return { load, reload, items, pages, isFetching, isEmpty, isPaginating };
}
