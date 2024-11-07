import Animated from 'react-native-reanimated'
import { Flex } from 'ui/src/components/layout/Flex'

/**
 * @deprecated  Prefer <Flex animation="" />
 *
 *    See: https://tamagui.dev/docs/core/animations
 */
export const AnimatedFlex = Animated.createAnimatedComponent(Flex)
AnimatedFlex.displayName = 'AnimatedFlex'
