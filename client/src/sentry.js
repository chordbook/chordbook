import * as Sentry from '@sentry/vue'

const SENTRY_DSN = import.meta.env.APP_SENTRY_DSN
const HOSTNAME = import.meta.env.APP_HOSTNAME

export default function (app, router) {
  if (!SENTRY_DSN) return

  Sentry.init({
    app,
    dsn: SENTRY_DSN,
    trackComponents: true,
    integrations: [
      Sentry.browserTracingIntegration({ router }),
      Sentry.replayIntegration()
    ],
    tracesSampleRate: 0.1,
    tracePropagationTargets: ['localhost', HOSTNAME]
  })
}
