import type { IonicConfig } from "@ionic/core";

const config: IonicConfig = {};

if (navigator.platform.includes("Mac")) {
  config.mode = "ios";
}

export default config;
