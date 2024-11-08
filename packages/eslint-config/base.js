module.exports = {
  env: {
    es6: true,
    node: true,
  },
  plugins: ['import', 'unused-imports', 'check-file'],
  extends: ['eslint:recommended'],
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
  },
  rules: {
    'check-file/no-index': ['error', { ignoreMiddleExtensions: true }],
    'import/no-unused-modules': ['error', { unusedExports: true }],
    'object-shorthand': ['error', 'always'],
    'unused-imports/no-unused-imports': 'error',
    'consistent-return': ['error', { treatUndefinedAsUnspecified: false }],
  },
  overrides: [
    {
      files: ['*.ts', '*.tsx'],
      parser: '@typescript-eslint/parser',
      plugins: ['@typescript-eslint/eslint-plugin'],
      extends: ['plugin:@typescript-eslint/recommended', 'plugin:import/typescript'],
      settings: {
        'import/parsers': {
          '@typescript-eslint/parser': ['.ts', '.tsx'],
        },
        'import/resolver': {
          typescript: {
            alwaysTryTypes: true,
          },
        },
      },
      rules: {
        curly: 'error',
        '@typescript-eslint/no-explicit-any': 'off',
        '@typescript-eslint/ban-ts-comment': 'off',
        '@typescript-eslint/ban-ts-ignore': 'off',
        '@typescript-eslint/explicit-module-boundary-types': 'off',
        '@typescript-eslint/explicit-function-return-type': 'off',
      },
    },
    {
      files: ['*.ts', '*.tsx'],
      excludedFiles: ['*.test.ts', '*.test.tsx'],
      rules: {
        'no-console': 'error',
      },
    },
    {
      files: ['**/__tests__/**/*.[jt]s?(x)', '**/?(*.)+(spec|test).[tj]s?(x)'],
      env: {
        jest: true,
        'jest/globals': true,
      },
      extends: ['plugin:jest/recommended'],
      plugins: ['jest'],
    },
  ],
}
