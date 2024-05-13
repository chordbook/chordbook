import arrify from "arrify";

export function pluralize(count, singular, plural) {
  return [count, count === 1 ? singular : plural].join(" ");
}

export function formatArray(args) {
  return new Intl.ListFormat().format(arrify(args));
}

export function formatDate(input) {
  if (!input) return "";
  const date = new Date(input);
  return new Intl.DateTimeFormat(navigator.language).format(date);
}

export function hostname(url) {
  try {
    return new URL(url).hostname;
  } catch {
    return url;
  }
}
