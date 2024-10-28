import { EtherscanLogoDark } from 'ui/src/components/logos/EtherscanLogoDark'
import { EtherscanLogoLight } from 'ui/src/components/logos/EtherscanLogoLight'
import { ChainLogoInfo } from 'peach/src/types/chains'
import { constants } from 'starknet'

// Keeping this separate from UNIVERSE_CHAIN_INFO to avoid import issues on extension content script
export const UNIVERSE_CHAIN_LOGO = {
  [constants.StarknetChainId.SN_MAIN]: {
    explorer: {
      logoLight: EtherscanLogoLight,
      logoDark: EtherscanLogoDark,
    },
  } as const satisfies ChainLogoInfo,
  [constants.StarknetChainId.SN_SEPOLIA]: {
    explorer: {
      logoLight: EtherscanLogoLight,
      logoDark: EtherscanLogoDark,
    },
  } as const satisfies ChainLogoInfo,
}
