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
import { usePaginatedFetch } from "@/composables";
import useAuthStore from "@/stores/auth";
import { reactive, watch } from "vue";
import PaginatedList from "./PaginatedList.vue";

import type { Params, UseFetchOptionsWithParams } from "@/composables";

const props = defineProps<{
  src: string;
  params?: Params;
  options?: UseFetchOptionsWithParams;
}>();

const emit = defineEmits(["load"]);
const auth = useAuthStore();
const pager = reactive(usePaginatedFetch(props.src, { ...props.options, params: props.params }));

pager.onFetchResponse(() => emit("load", pager));

// Reload data when signing in/out
watch(
  () => auth.isAuthenticated,
  () => {
    console.log("isAuthenticated changed", auth.isAuthenticated);
    pager.reload();
  },
);

defineExpose(pager);

await pager;
</script>

<template>
  <PaginatedList
    :paginate="pager.isPaginating"
    @load="$event.waitUntil(pager.load())"
    @reload="$event.waitUntil(pager.reload())"
  >
    <slot v-if="$slots.empty && pager.isEmpty" name="empty" />
    <slot v-else v-bind="pager" />
  </PaginatedList>
</template>
