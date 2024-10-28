import type { Middleware, PreloadedState } from '@reduxjs/toolkit'
import { MMKV } from 'react-native-mmkv'
import { Storage, persistReducer, persistStore } from 'redux-persist'
import { MobileState, mobilePersistedStateList, mobileReducer } from 'src/app/mobileReducer'
import { isNonJestDev } from 'utilities/src/environment/constants'
import { createStore } from 'peach/src/state'

const storage = new MMKV()

export const reduxStorage: Storage = {
  setItem: (key, value) => {
    storage.set(key, value)
    return Promise.resolve(true)
  },
  getItem: (key) => {
    const value = storage.getString(key)
    return Promise.resolve(value)
  },
  removeItem: (key) => {
    storage.delete(key)
    return Promise.resolve()
  },
}

export const persistConfig = {
  key: 'root',
  storage: reduxStorage,
  whitelist: mobilePersistedStateList,
}

export const persistedReducer = persistReducer(persistConfig, mobileReducer)

const middlewares: Middleware[] = []

if (isNonJestDev) {
  const createDebugger = require('redux-flipper').default
  middlewares.push(createDebugger())
}

export const setupStore = (
  preloadedState?: PreloadedState<MobileState>,
  // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
) => {
  return createStore({
    reducer: persistedReducer,
    preloadedState,
    middlewareAfter: [...middlewares],
  })
}
export const store = setupStore()

export const persistor = persistStore(store)
