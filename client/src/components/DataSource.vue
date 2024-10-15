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
<script setup>
import { reactive, watch } from "vue";
import usePaginatedFetch from "@/composables/usePaginatedFetch";
import useAuthStore from "@/stores/auth";

const props = defineProps({
  src: {
    type: String,
    required: true,
  },
  params: {
    type: Object,
    default() {
      return {};
    },
  },
  options: {
    type: Object,
    default() {
      return {};
    },
  },
});

const emit = defineEmits(["load"]);

const pager = reactive(
  usePaginatedFetch(props.src, { ...props.options, params: props.params }),
);

function load() {
  const page = pager.load();
  page.onFetchResponse(() => emit("load", page));
  return page;
}

const auth = useAuthStore();

defineExpose(pager);

// Reload data when signing in/out
watch(() => auth.isAuthenticated, () => {
  console.log("isAuthenticated changed", auth.isAuthenticated)
  pager.reload()
});

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

  <ion-infinite-scroll
    v-if="pager.isPaginating"
    @ion-infinite="load().then(() => $event.target.complete())"
  >
    <ion-infinite-scroll-content
      loading-spinner="bubbles"
      loading-text="Loading…"
    />
  </ion-infinite-scroll>
</template>
