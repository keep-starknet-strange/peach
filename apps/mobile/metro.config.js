/**
 * Metro configuration for React Native with support for SVG files
 * https://github.com/react-native-svg/react-native-svg#use-with-svg-files
 *
 * @format
 */
const { getMetroAndroidAssetsResolutionFix } = require('react-native-monorepo-tools')
const androidAssetsResolutionFix = getMetroAndroidAssetsResolutionFix()

const path = require('path')
const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');

const mobileRoot = path.resolve(__dirname)
const workspaceRoot = path.resolve(mobileRoot, '../..')

const watchFolders = [mobileRoot, `${workspaceRoot}/node_modules`, `${workspaceRoot}/packages`]

const defaultConfig = getDefaultConfig(__dirname);

const {
  resolver: { sourceExts, assetExts },
} = defaultConfig;

const config = {
  resolver: {
    nodeModulesPaths: [`${workspaceRoot}/node_modules`],
    assetExts: assetExts.filter((ext) => ext !== 'svg'),
    sourceExts: [...sourceExts, 'svg', 'cjs'],
    extraNodeModules: {
      // Add polyfills for Node.js core modules
      'path': require.resolve('path-browserify'),
      'os': require.resolve('os-browserify/browser'),
    },
  },
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
    babelTransformerPath: require.resolve('react-native-svg-transformer'),
    publicPath: androidAssetsResolutionFix.publicPath,
  },
  server: {
    enhanceMiddleware: (middleware) => {
      return androidAssetsResolutionFix.applyMiddleware(middleware)
    },
  },
  watchFolders,
}

module.exports = mergeConfig(defaultConfig, config);
