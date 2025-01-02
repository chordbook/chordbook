import { useFetch } from "@/client";
import console from "@/console";
import { useStorage } from "@vueuse/core";
import { defineStore } from "pinia";
import { computed, reactive, toValue, watch } from "vue";
import { useRouter } from "vue-router";

import type { SignUp } from "@/api";
import type { BeforeFetchContext, RemovableRef, UseFetchReturn } from "@vueuse/core";
import type { MaybeRef } from "vue";

export default defineStore("auth", () => {
  // Accepting the security trade-offs of persisting in localStorage. There is no other reasonable
  // method to keep the user signed across page reloads and multiple browser tabs. The access token
  // expiry is short and the refresh token is rotated every time it is used, so risk is reduced.
  // If anyone knows a better way to persist this securely, please share it.
  const user = useStorage("user", {}) as RemovableRef<Record<string, string>>;
  const accessToken = useStorage("accessToken", "");
  const expireAt = useStorage("expireAt", 0);
  const refreshToken = useStorage("refreshToken", "");
  const isAuthenticated = computed(() => !!user.value.id);

  const refreshPayload = computed(() => ({
    refresh_token: refreshToken.value,
  }));
  const refreshFetch = reactive(
    useFetch("authenticate", {
      options: { credentials: "omit" },
      immediate: false,
      afterFetch(ctx) {
        authenticated(ctx);
        return ctx;
      },
      onFetchError(ctx) {
        if (ctx.response?.status === 401) {
          console.error("auth: failed to refresh token", ctx.error);
          reset();
        }
        return ctx;
      },
    })
      .put(refreshPayload)
      .json(),
  );

  function signUp(data: MaybeRef<SignUp["user"]>, useFetchOptions = {}) {
    const fetch = useFetch("users", {
      updateDataOnError: true,
      ...useFetchOptions,
    })
      .post({ user: toValue(data) })
      .json();
    fetch.onFetchResponse(() => authenticated(fetch));
    return fetch;
  }

  function signIn(data: MaybeRef<Record<string, string>>, useFetchOptions = {}) {
    const fetch = useFetch("authenticate", {
      updateDataOnError: true,
      ...useFetchOptions,
    })
      .post(data)
      .json();
    fetch.onFetchResponse(() => authenticated(fetch));
    return fetch;
  }

  function forgotPassword(data: MaybeRef<Record<string, string>>, useFetchOptions = {}) {
    return useFetch("password", { updateDataOnError: true, ...useFetchOptions })
      .post(data)
      .json();
  }

  function resetPassword(data: MaybeRef<Record<string, string>>, useFetchOptions = {}) {
    return useFetch("password", { updateDataOnError: true, ...useFetchOptions })
      .put(data)
      .json();
  }

  function signOut() {
    return useFetch("authenticate", { beforeFetch: reset }).delete();
  }

  function needsRefresh() {
    return expireAt.value - new Date().valueOf() < 1000; // 1 second grace period
  }

  function refresh() {
    if (!refreshFetch.isFetching && refreshToken.value) {
      console.log("auth: refreshing token");
      refreshFetch.execute(true);
    }

    return refreshFetch;
  }

  function reset() {
    accessToken.value = null;
    refreshToken.value = null;
    expireAt.value = 0;
    user.value = {};

    console.debug("auth: reset");
  }

  function authenticated({
    data,
    response,
  }: {
    data: MaybeRef<any>;
    response: MaybeRef<Response | null>;
  }) {
    const { headers } = toValue(response) || {};
    if (!headers) return; // nothing to do

    accessToken.value = headers.get("access-token");
    expireAt.value = Number(headers.get("expire-at")) * 1000;
    refreshToken.value = headers.get("refresh-token");
    user.value = toValue(data);

    console.debug("auth: authenticated", user.value);
  }

  async function beforeFetch({ url, options }: BeforeFetchContext) {
    if (options.credentials !== "omit" && accessToken.value) {
      if (needsRefresh()) {
        console.debug("auth: token is expired, refreshing before fetch", {
          url,
          options,
        });
        await refresh();
      }

      console.debug("auth: adding credentials to request", {
        url,
        options,
        expireAt: expireAt.value,
      });
      options.credentials = "include";
      options.headers = {
        Authorization: `Bearer ${accessToken.value}`,
        ...options.headers,
      };

      return { options };
    }
  }

  function handleExpiredToken(fetch: UseFetchReturn<unknown>) {
    if (refreshToken.value && fetch.statusCode.value === 401) {
      console.warn("auth: token is invalid, trying to refresh");
      refresh().then(() => {
        console.info("auth: token refreshed, retrying", fetch.response.value?.url);
        fetch.execute();
      });
    }
  }

  const router = useRouter();

  function assert() {
    if (isAuthenticated.value) return true;

    router.push("#signup");
    return false;
  }

  function guard(callback: CallableFunction) {
    return () => assert() && callback();
  }

  // Abort refresh if refreshed from another tab
  watch(refreshToken, () => refreshFetch.isFetching && refreshFetch.abort());

  return {
    beforeFetch,
    handleExpiredToken,
    user,
    isAuthenticated,
    signUp,
    signIn,
    signOut,
    forgotPassword,
    resetPassword,
    refresh,
    assert,
    guard,
  };
});
