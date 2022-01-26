import hash from 'string-hash'
import color from 'tinycolor2'

const defaults = {
  colors: 3,
  spin: 45
}

// Generate a gradient for a given string
export function gradient (uid, options = {}) {
  const n = hash(uid)
  const { colors, spin } = Object.assign(defaults, options)

  const base = color({
    h: n % 360, // 360º
    s: 50 + (n % 50), // 50-100
    l: 30 + (n % 20) // 30-50
  })

  const gradient = []

  for (let i = 0; i < colors; i++) {
    const sign = i % 2 === 0 ? -1 : 1
    const color = base.clone()
      .spin(i * spin)
      .darken(n % 10 * sign)
      .desaturate(n % 15 * sign)
    gradient.push(color)
  }

  return `linear-gradient(${n % 360}deg, ${gradient.join(', ')})`
}
