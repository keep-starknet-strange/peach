import { combineReducers } from 'redux'
import { PersistState } from 'redux-persist'
import { appearanceSettingsReducer } from 'peach/src/features/appearance/slice'

export const appReducers = {
  appearanceSettings: appearanceSettingsReducer,
} as const

// used to type RootState
export const appRootReducer = combineReducers(appReducers)

export const appPersistedStateList: Array<keyof typeof appReducers> = [
  'appearanceSettings',
]

export type AppStateReducersOnly = ReturnType<typeof appRootReducer>
export type AppState = AppStateReducersOnly & { _persist?: PersistState }
