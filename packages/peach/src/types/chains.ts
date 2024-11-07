import { Token } from '@uniswap/sdk-core'
import type { ImageSourcePropType } from 'react-native'
import { constants as StarknetConstants } from 'starknet'
import { GeneratedIcon } from 'ui/src'

export type ChainId = StarknetConstants.StarknetChainId

export interface ChainInfo {
  readonly id: ChainId
  readonly explorer: {
    name: string
    url: string
  }
  readonly junoPrefix: string | undefined
  readonly logo?: ImageSourcePropType
  readonly stablecoin: Token
}

export interface ChainLogoInfo {
  explorer: {
    logoLight: GeneratedIcon
    logoDark: GeneratedIcon
  }
}
