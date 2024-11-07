import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import { AppState } from 'peach/src/state/appReducer'

export enum AppearanceSettingType {
  System = 'system',
  Light = 'light',
  Dark = 'dark',
}

export interface AppearanceSettingsState {
  selectedAppearanceSettings: AppearanceSettingType
  hapticsEnabled: boolean
}

export const initialAppearanceSettingsState: AppearanceSettingsState = {
  selectedAppearanceSettings: AppearanceSettingType.System,
  hapticsEnabled: true,
}

const slice = createSlice({
  name: 'appearanceSettings',
  initialState: initialAppearanceSettingsState,
  reducers: {
    setSelectedAppearanceSettings: (state, action: PayloadAction<AppearanceSettingType>) => {
      state.selectedAppearanceSettings = action.payload
    },
    resetSettings: () => initialAppearanceSettingsState,
    setHapticsUserSettingEnabled: (state, { payload }: PayloadAction<boolean>) => {
      state.hapticsEnabled = payload
    },
  },
})

export const { setSelectedAppearanceSettings, resetSettings, setHapticsUserSettingEnabled } = slice.actions

export const selectHapticsEnabled = (state: AppState): boolean => state.appearanceSettings.hapticsEnabled

export const appearanceSettingsReducer = slice.reducer
