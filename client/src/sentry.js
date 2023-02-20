import * as Sentry from '@sentry/vue'
import { BrowserTracing } from '@sentry/tracing'

const SENTRY_DSN = import.meta.env.APP_SENTRY_DSN
const HOSTNAME = import.meta.env.APP_HOSTNAME

export default function (app, router) {
  if (!SENTRY_DSN) return

  Sentry.init({
    app,
    dsn: SENTRY_DSN,
    trackComponents: true,
    integrations: [
      new BrowserTracing({
        routingInstrumentation: Sentry.vueRouterInstrumentation(router),
        tracingOrigins: ['localhost', HOSTNAME, /^\//]
      })
    ],
    // Set tracesSampleRate to 1.0 to capture 100%
    // of transactions for performance monitoring.
    // We recommend adjusting this value in production
    tracesSampleRate: 0.1
  })
}
