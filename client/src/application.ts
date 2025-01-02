import "./application.css";

import { IonicVue } from "@ionic/vue";
import { createHead } from "@vueuse/head";
import FloatingVue from "floating-vue";
import { createPinia } from "pinia";
import { createApp } from "vue";
import * as components from "./components";
import ionicConfig from "./config";
import router from "./router";
import useSentry from "./sentry";
import telemetry from "./telemetry";
import App from "./views/App.vue";

const app = createApp(App)
  .use(createHead({ titleTemplate: "%s - Chord Book" }))
  .use(createPinia())
  .use(IonicVue, ionicConfig)
  .use(router)
  .use(FloatingVue, {
    themes: {
      tooltip: {
        triggers: ["hover"], // Only trigger on hover
        hideTriggers: (events: string[]) => events, // don't close on click
      },
    },
  });

for (const name in components) {
  app.component(name, components[name as keyof typeof components]);
}

useSentry(app, router);

router.isReady().then(() => {
  telemetry();
  app.mount("[data-behavior=vue]");
});
