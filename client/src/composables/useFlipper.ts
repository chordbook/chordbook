import { useFetch } from "./useFetch";
import { computed, reactive } from "vue";

const fetch = reactive(useFetch("flipper", { immediate: false }).get().json());

export default function (feature: string, defaultValue = false) {
  // Fetch flipper data if it hasn't been fetched yet
  if (!fetch.isFetching && !fetch.isFinished) fetch.execute();

  return {
    isEnabled: computed(() => fetch.data?.[feature] ?? defaultValue),
  };
}
