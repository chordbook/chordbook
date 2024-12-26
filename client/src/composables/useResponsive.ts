import { useMediaQuery } from "@vueuse/core";

const breakpoints = {
  xs: useMediaQuery("(min-width: 0px"),
  sm: useMediaQuery("(min-width: 576px"),
  md: useMediaQuery("(min-width: 768px"),
  lg: useMediaQuery("(min-width: 992px"),
  xl: useMediaQuery("(min-width: 1200px"),
};

export default function useResponsive(size: keyof typeof breakpoints) {
  return breakpoints[size];
}
