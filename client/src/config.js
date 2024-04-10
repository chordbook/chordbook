const mac = (window) => window.navigator.platform.includes('Mac')
const touch = (window) => ('ontouchstart' in window)

const config = {
  platform: { mac, touch }
}

if (localStorage.getItem('ion-mode')) {
  config.mode = localStorage.getItem('ion-mode')
} else if (mac(window)) {
  config.mode = 'ios'
}

export default config
