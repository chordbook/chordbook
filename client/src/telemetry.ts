const domain = import.meta.env.APP_HOSTNAME;

export default function () {
  if (domain && import.meta.env.PROD) {
    const script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "https://plausible.io/js/plausible.js";
    script.dataset.domain = domain;
    document.head.appendChild(script);
  }
}
