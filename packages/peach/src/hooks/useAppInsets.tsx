import { useDeviceInsets } from 'ui/src/hooks/useDeviceInsets'
import { useEnabledChain } from 'peach/src/features/chains/utils'
import { isMobileApp } from 'utilities/src/platform'

export const TESTNET_MODE_BANNER_HEIGHT = 44

export const useAppInsets = (): {
  top: number
  right: number
  bottom: number
  left: number
} => {
  const { isTestnet } = useEnabledChain()
  const insets = useDeviceInsets()

  const extraTop = isTestnet && isMobileApp ? TESTNET_MODE_BANNER_HEIGHT : 0
  return { ...insets, top: insets.top + extraTop }
}
