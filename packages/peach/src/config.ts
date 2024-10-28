import {
  SN_NETWORK_NAME,
} from 'react-native-dotenv'
import { isNonJestDev } from 'utilities/src/environment/constants'

/**
 * Naming requirements for different environments:
 * - Web ENV vars: must have process.env.REACT_APP_<var_name>
 * - Extension ENV vars: must have process.env.<var_name>
 * - Mobile ENV vars: must have BOTH process.env.<var_name> and <var_name>
 *
 *  The CI requires web vars to have the required 'REACT_APP_' prefix. The react-dot-env library doesnt integrate with CI correctly,
 *  so we pull from github secrets directly with process.env.<var_name> for both extension and mobile. <var_name> is used for local mobile builds.
 */

export interface Config {
  snNetworkName: string
}

/**
 * Naming requirements for different environments:
 * - Web ENV vars: must have process.env.REACT_APP_<var_name>
 * - Extension ENV vars: must have process.env.<var_name>
 * - Mobile ENV vars: must have BOTH process.env.<var_name> and <var_name>
 *
 *  The CI requires web vars to have the required 'REACT_APP_' prefix. The react-dot-env library doesnt integrate with CI correctly,
 *  so we pull from github secrets directly with process.env.<var_name> for both extension and mobile. <var_name> is used for local mobile builds.
 */

const _config: Config = {
  snNetworkName: process.env.SN_NETWORK_NAME || SN_NETWORK_NAME,
}

export const config = Object.freeze(_config)

if (isNonJestDev) {
  // Cannot use logger here, causes error from circular dep
  // eslint-disable-next-line no-console
  console.debug('Using app config:', config)
}
