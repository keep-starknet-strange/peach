import { config } from 'peach/src/config'
import { useMemo } from 'react'
import { constants } from 'starknet'

export function isMainnetChain(networkName: constants.NetworkName): boolean {
  return networkName === constants.NetworkName.SN_MAIN
}

export function useEnabledChain(): {
  isTestnet: boolean
} {
  return useMemo(() => ({ isTestnet: !isMainnetChain(config.snNetworkName as constants.NetworkName) }), [])
}
