<!--

A component that loads data from the API with automatic pagination.

Load one page of data:

  <data-source src="/thing/1" v-slot="{ data }">
    {{ data?.name }}
  </data-source>

Load a paginated list of items:

  <data-source src="/things" v-slot="{ items }">
    <div v-for="thing in items"></div>
  </data-source>

Or explicitly render each page

  <data-source src="/things">
    <template #page="{ data, isFetching, error }">
      <div v-for="thing in data"></div>
    </template>
  </data-source>

Empty placeholder:

  <data-source src="/things">
    <template #empty>No Items to display</template>
    <template #default="{ items }">…</template>
  </data-source>
-->
<script lang="ts" setup>
import usePaginatedFetch from "@/composables/usePaginatedFetch";
import useAuthStore from "@/stores/auth";
import { reactive, watch } from "vue";

import type { Params, UseFetchOptionsWithParams } from "@/composables";

const props = defineProps<{
  src: string;
  params?: Params;
  options?: UseFetchOptionsWithParams;
}>();

const emit = defineEmits(["load"]);

const pager = reactive(usePaginatedFetch(props.src, { ...props.options, params: props.params }));

function load() {
  const page = pager.load();
  page?.onFetchResponse(() => emit("load", page));
  return page;
}

const auth = useAuthStore();

defineExpose(pager);

// Reload data when signing in/out
watch(
  () => auth.isAuthenticated,
  () => {
    console.log("isAuthenticated changed", auth.isAuthenticated);
    pager.reload();
  },
);

await load();
</script>

<template>
  <slot v-if="$slots.empty && pager.isEmpty" name="empty" />
  <template v-else>
    <template v-for="page in pager.pages">
      <slot v-if="$slots.page" name="page" v-bind="page" />
    </template>
    <slot v-bind="{ items: pager.items, ...pager.pages[0] }" />
  </template>

  <IonInfiniteScroll
    v-if="pager.isPaginating"
    @ion-infinite="load()?.then(() => $event.target.complete())"
  >
    <IonInfiniteScrollContent loading-spinner="bubbles" loading-text="Loading…" />
  </IonInfiniteScroll>
</template>
