import { useMediaQuery } from '@vueuse/core'

const breakpoints = {
  xs: '0px',
  sm: '576px',
  md: '768px',
  lg: '992px',
  xl: '1200px'
}

export default function useResponsive (size) {
  return useMediaQuery(`(min-width: ${breakpoints[size]})`)
}
