interface ImportMetaEnv {
  readonly APP_HOSTNAME: string;
  readonly APP_API_URL: string;
  readonly MODE: string;
  readonly PROD: boolean;
  readonly DEV: boolean;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
