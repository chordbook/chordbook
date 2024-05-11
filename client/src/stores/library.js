import { defineStore } from "pinia";
import { ref, watch, unref } from "vue";
import { useFetch } from "@/client";
import useAuthStore from "@/stores/auth";

export default (id) => {
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
