<!--

A component that loads data from the API

Load one page of data:

  <data-source src="/thing/1" v-slot="{ data }">
    {{ data?.name }}
  </data-source>

Load a paginated list:

  <data-source src="/things" v-slot="{ items }" paginate>
    <div v-for="thing in items"></div>
  </data-source>

Empty placeholer:

  <data-source src="/things" v-slot="{ items }" paginate>
    <template #empty>No Items to display</template>
    <template #default="{ items }">…</template>
  </data-source>
-->
<script setup>
import { defineProps, reactive } from 'vue'
import { useDataSource } from '@/client'

const props = defineProps({
  src: {
    type: String,
    required: true
  },
  params: {
    type: Object,
    default () { return { } }
  },
  paginate: {
    type: Boolean,
    default: false
  }
})

const dataSource = reactive(useDataSource(props.src, props.params))

defineExpose({ dataSource })
</script>

<template>
  <slot
    v-if="$slots.empty && dataSource.isEmpty"
    name="empty"
  />
  <template v-else-if="paginate">
    <slot v-bind="dataSource" />
    <template v-for="page in dataSource.pages">
      <slot
        name="page"
        v-bind="page"
      />
    </template>
    <ion-infinite-scroll
      v-if="paginate"
      threshold="500px"
      :disabled="dataSource.isDisabled"
      @ion-infinite="dataSource.load().then(() => $event.target.complete())"
    >
      <ion-infinite-scroll-content
        loading-spinner="bubbles"
        loading-text="Loading…"
      />
    </ion-infinite-scroll>
  </template>
  <slot
    v-else
    v-bind="dataSource.pages[0]"
  />
</template>
