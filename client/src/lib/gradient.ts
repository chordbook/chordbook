import hash from "string-hash";
import color from "tinycolor2";

// Generate a gradient for a given string
export function gradient(uid: string, options: { colors?: number; spin?: number } = {}) {
  const n = hash(uid);
  const colors = options.colors ?? 3;
  const spin = options.spin ?? 45;

  const base = color({
    h: n % 360, // 360º
    s: 50 + (n % 50), // 50-100
    l: 30 + (n % 20), // 30-50
  });

  const gradient = [];

  for (let i = 0; i < colors; i++) {
    const sign = i % 2 === 0 ? -1 : 1;
    const color = base
      .clone()
      .spin(i * spin)
      .darken((n % 10) * sign)
      .desaturate((n % 15) * sign);
    const deg = (n % 360) + i * (360 / colors);
    gradient.push(`linear-gradient(${deg}deg, ${color}, ${color.clone().setAlpha(0)} 90%)`);
  }

  return gradient.join(", ");
}
