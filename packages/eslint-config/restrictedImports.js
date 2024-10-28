exports.shared = {
  patterns: [
    {
      group: ['**/dist'],
      message: 'Do not import from dist/ - this is an implementation detail, and breaks tree-shaking.',
    },
  ],
}

exports.crossPlatform = {
  patterns: [
    ...exports.shared.patterns,
    {
      group: [
        '*react-native*',
        // The following are allowed to be imported in cross-platform code.
        '!react-native-reanimated',
        '!react-native-image-colors',
        '!@testing-library/react-native',
        '!@react-native-community/netinfo',
        '!react-native-localize',
      ],
      message:
        "React Native modules should not be imported outside of .native.ts files. If this is a .native.ts file, add an ignore comment to the top of the file. If you're trying to import a cross-platform module, add it to the whitelist in crossPlatform.js.",
    },
  ],
}
