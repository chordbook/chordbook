import {
  onIonViewWillEnter,
  onIonViewDidEnter,
  onIonViewWillLeave,
  onIonViewDidLeave,
} from "@ionic/vue";
import { ref, provide, watchEffect } from "vue";

import type { Ref } from "vue";

export interface IonPageLifecycle {
  entering: Ref<boolean>;
  active: Ref<boolean>;
  leaving: Ref<boolean>;
  onDidEnter: (fn: CallableFunction) => void;
  onWillLeave: (fn: CallableFunction) => void;
}

// Ionic only makes the onIonView* events available to the top-level view under a
// ion-router-outlet. This listens for those events and exposes it as reactive state
// to sub-components using provide/inject.
export default function useIonPageLifecycle() {
  const entering = ref(false);
  const active = ref(false);
  const leaving = ref(false);

  onIonViewWillEnter(() => {
    entering.value = true;
  });

  onIonViewDidEnter(() => {
    entering.value = false;
    active.value = true;
  });

  onIonViewWillLeave(() => {
    leaving.value = true;
  });

  onIonViewDidLeave(() => {
    active.value = leaving.value = false;
  });

  function onDidEnter(fn: CallableFunction) {
    watchEffect(() => {
      if (active.value) fn();
    });
  }

  function onWillLeave(fn: CallableFunction) {
    watchEffect(() => {
      if (leaving.value) fn();
    });
  }

  const page = { entering, active, leaving, onDidEnter, onWillLeave };

  // provide page to nested components
  provide<IonPageLifecycle>("page", page);

  return page;
}
