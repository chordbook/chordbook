const domain = import.meta.env.HOSTNAME

export default function () {
  if (domain) {
    const script = document.createElement('script')
    script.type = 'text/javascript'
    script.src = 'https://plausible.io/js/plausible.js'
    script.dataset.domain = domain
    document.head.appendChild(script)
  }
}
