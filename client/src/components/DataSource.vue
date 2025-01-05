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
const fetch = reactive(
  usePaginatedFetch(props.src, {
    ...props.options,
    params: props.params,
    immediate: false,
  }),
);

async function loadMore() {
  await fetch.load();
  emit("load", fetch);
}

const auth = useAuthStore();

defineExpose(fetch);

// Reload data when signing in/out
watch(
  () => auth.isAuthenticated,
  () => {
    console.log("isAuthenticated changed", auth.isAuthenticated);
    fetch.reload();
  },
);

await loadMore();
</script>

<template>
  <slot v-if="$slots.empty && fetch.isEmpty" name="empty" />
  <template v-else>
    <slot v-bind="fetch" />
  </template>

  <ion-infinite-scroll
    v-if="fetch.isPaginating"
    @ion-infinite="loadMore().then(() => $event.target.complete())"
  >
    <ion-infinite-scroll-content loading-spinner="bubbles" loading-text="Loading…" />
  </ion-infinite-scroll>
</template>
