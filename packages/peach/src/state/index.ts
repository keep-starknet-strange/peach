import type { Middleware, PreloadedState, Reducer, StoreEnhancer } from '@reduxjs/toolkit'
import { configureStore } from '@reduxjs/toolkit'
import { AppStateReducersOnly } from 'peach/src/state/appReducer'

interface CreateStoreProps {
  reducer: Reducer
  enhancers?: Array<StoreEnhancer>
  // middlewares to add after the default middleware
  // recommended over `middlewareBefore`
  middlewareAfter?: Array<Middleware<unknown>>
  // middlewares to before after the default middleware
  middlewareBefore?: Array<Middleware<unknown>>
  preloadedState?: PreloadedState<AppStateReducersOnly>
}

// Disable eslint rule to infer return type from the returned value
// (it is complex and not worth the effort to type it manually)
// eslint-disable-next-line @typescript-eslint/explicit-function-return-type
export function createStore({
  middlewareAfter = [],
  middlewareBefore = [],
  preloadedState = {},
  enhancers = [],
  reducer,
}: CreateStoreProps) {
  const store = configureStore({
    reducer,
    preloadedState,
    enhancers,
    middleware: (getDefaultMiddleware) =>
      getDefaultMiddleware({
        // required for rtk-query
        thunk: true,
        // turn off since it slows down for dev and also doesn't run in prod
        // TODO: [MOB-641] figure out why this is slow
        serializableCheck: false,
        invariantCheck: {
          warnAfter: 256,
        },
        // slows down dev build considerably
        immutableCheck: false,
      })
        .prepend(middlewareBefore)
        .concat(middlewareAfter),
    devTools: __DEV__,
  })

  return store
}
