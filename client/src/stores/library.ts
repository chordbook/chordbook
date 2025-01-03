import { useFetch } from "@/composables";
import useAuthStore from "@/stores/auth";
import { defineStore } from "pinia";
import { ref, unref, watch } from "vue";

export default (id: string) => {
  return defineStore(`Library:${id}`, () => {
    const auth = useAuthStore();
    const exists = ref(false);

    watch(
      () => auth.isAuthenticated,
      () => {
        if (!auth.isAuthenticated) return;
        useFetch("library", { params: { id } }).then(({ statusCode }) => {
          exists.value = unref(statusCode) === 200;
        });
      },
      { immediate: true },
    );

    const add = auth.guard(() => {
      return useFetch("library")
        .post({ id })
        .then(async () => {
          exists.value = true;
        });
    });

    const remove = auth.guard(() => {
      return useFetch("library")
        .delete({ id })
        .then(() => {
          exists.value = false;
        });
    });

    return { exists, add, remove };
  })();
};
