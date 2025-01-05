import * as Sentry from "@sentry/vue";

import type { App } from "vue";
import type { Router } from "vue-router";

const SENTRY_DSN = import.meta.env.APP_SENTRY_DSN;
const HOSTNAME = import.meta.env.APP_HOSTNAME;

export default function (app: App, router: Router) {
  if (!SENTRY_DSN) return;

  Sentry.init({
    app,
    dsn: SENTRY_DSN,
    trackComponents: true,
    integrations: [Sentry.browserTracingIntegration({ router }), Sentry.replayIntegration()],
    tracesSampleRate: 0.1,
    tracePropagationTargets: ["localhost", HOSTNAME],
  });
}
