const { crossPlatform: restrictedImports } = require('@peach/eslint-config/restrictedImports')

module.exports = {
  overrides: [
    {
      files: ['*.ts', '*.tsx'],
      excludedFiles: ['*.native.*', '*.ios.*', '*.android.*'],
      rules: {
        'no-restricted-imports': ['error', restrictedImports],
      },
    },
  ],
}
