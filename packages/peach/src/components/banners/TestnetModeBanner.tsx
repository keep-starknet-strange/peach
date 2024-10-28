import { Flex, FlexProps, Text, isWeb } from 'ui/src'
import { Wrench } from 'ui/src/components/icons/Wrench'
import { useDeviceInsets } from 'ui/src/hooks/useDeviceInsets'
import { TESTNET_MODE_BANNER_HEIGHT } from 'peach/src/hooks/useAppInsets'
import { isInterface, isMobileApp } from 'utilities/src/platform'
import { useEnabledChain } from 'peach/src/features/chains/utils'

export function TestnetModeBanner(props: FlexProps): JSX.Element | null {
  const { isTestnet } = useEnabledChain()

  const { top } = useDeviceInsets()

  if (!isTestnet) {
    return null
  }

  return (
    <Flex
      row
      centered
      top={top}
      position={isMobileApp ? 'absolute' : 'relative'}
      zIndex="$sticky"
      width={isInterface ? 'auto' : '100%'}
      p="$padding12"
      gap="$gap8"
      backgroundColor="$statusSuccess2"
      borderWidth={isWeb ? 0 : 1}
      borderBottomWidth={1}
      height={TESTNET_MODE_BANNER_HEIGHT}
      borderStyle="dashed"
      borderColor="$surface3"
      {...props}
    >
      <Wrench color="$greenBase" size="$icon.20" />
      <Text color="$greenBase" variant="body3">
        You are in testnet mode
      </Text>
    </Flex>
  )
}
