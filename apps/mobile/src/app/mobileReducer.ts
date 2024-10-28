import { combineReducers } from '@reduxjs/toolkit'
import { appPersistedStateList, appReducers } from 'peach/src/state/appReducer'

const mobileReducers = {
  ...appReducers,
} as const

export const mobileReducer = combineReducers(mobileReducers)

export const mobilePersistedStateList: Array<keyof typeof mobileReducers> = [
  ...appPersistedStateList,
]

export type MobileState = ReturnType<typeof mobileReducer>
