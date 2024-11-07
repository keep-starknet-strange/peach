// eslint-disable-next-line @typescript-eslint/triple-slash-reference
/// <reference path="../../../index.d.ts" />

// leave this blank
// don't re-export files from this workspace.
export {}

declare global {
  interface Window {
    Cypress?: unknown
  }
}
