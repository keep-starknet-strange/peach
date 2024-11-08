import { Path, Svg } from 'react-native-svg'

// eslint-disable-next-line no-relative-import-paths/no-relative-import-paths
import { createIcon } from '../factories/createIcon'

export const [Home, AnimatedHome] = createIcon({
  name: 'Home',
  getIcon: (props) => (
    <Svg viewBox="0 0 22 22" fill="none" {...props}>
      <Path
        d="M14 16C13.2005 16.6224 12.1502 17 11 17C9.84972 17 8.79953 16.6224 8 16"
        stroke="currentColor"
        strokeWidth="1.5"
        strokeLinecap="round"
      />
      <Path
        d="M1.35139 12.2135C0.99837 9.9162 0.82186 8.76763 1.25617 7.74938C1.69047 6.73112 2.65403 6.03443 4.58114 4.64106L6.02099 3.6C8.41829 1.86667 9.61692 1 11 1C12.383 1 13.5817 1.86667 15.979 3.6L17.4188 4.64106C19.346 6.03443 20.3095 6.73112 20.7438 7.74938C21.1781 8.76763 21.0016 9.9162 20.6486 12.2135L20.3476 14.1724C19.8471 17.4289 19.5969 19.0572 18.429 20.0286C17.2611 21 15.5536 21 12.1388 21H9.86122C6.44634 21 4.73891 21 3.571 20.0286C2.40309 19.0572 2.15287 17.4289 1.65243 14.1724L1.35139 12.2135Z"
        stroke="currentColor"
        strokeWidth="1.5"
        strokeLinejoin="round"
      />
    </Svg>
  ),
})
