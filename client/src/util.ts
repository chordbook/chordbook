import arrify from "arrify";

export function pluralize(count: number, singular: string, plural: string) {
  return [count, count === 1 ? singular : plural].join(" ");
}

export function formatArray(args: string | string[]) {
  return new Intl.ListFormat().format(arrify(args));
}

export function formatDate(input: string) {
  if (!input) return "";
  const date = new Date(input);
  return new Intl.DateTimeFormat(navigator.language).format(date);
}

export function hostname(url: string) {
  try {
    return new URL(url).hostname;
  } catch {
    return url;
  }
}
