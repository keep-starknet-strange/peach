import { BottomSheetModalProvider } from '@gorhom/bottom-sheet'
import { TestnetModeBanner } from 'peach/src/components/banners/TestnetModeBanner'
import { useSelectedColorScheme } from 'peach/src/features/appearance/hooks'
import { selectHapticsEnabled } from 'peach/src/features/appearance/slice'
import { SharedPeachProvider } from 'peach/src/providers/SharedPeachProvider'
import React, { StrictMode, useEffect } from 'react'
import { Appearance, StatusBar } from 'react-native'
import { SafeAreaProvider } from 'react-native-safe-area-context'
import { enableFreeze } from 'react-native-screens'
import { useSelector } from 'react-redux'
import { PersistGate } from 'redux-persist/integration/react'
import { NavigationContainer } from 'src/app/navigation/NavigationController'
import { AppStackNavigator } from 'src/app/navigation/navigation'
import { persistor, store } from 'src/app/store'
import { useHapticFeedback, useIsDarkMode } from 'ui/src'

enableFreeze(true)

function AppOuter(): JSX.Element | null {
  return (
    <PersistGate loading={null} persistor={persistor}>
      <NavigationContainer>
        <BottomSheetModalProvider>
          <AppInner />
        </BottomSheetModalProvider>
      </NavigationContainer>
    </PersistGate>
  )
}

export default function App(): JSX.Element | null {
  return (
    <StrictMode>
      <SafeAreaProvider>
        <SharedPeachProvider reduxStore={store}>
          <AppOuter />
        </SharedPeachProvider>
      </SafeAreaProvider>
    </StrictMode>
  )
}

function AppInner(): JSX.Element {
  const isDarkMode = useIsDarkMode()
  const themeSetting = useSelectedColorScheme()
  const hapticsUserEnabled = useSelector(selectHapticsEnabled)
  const { setHapticsEnabled } = useHapticFeedback()

  // Sets haptics for the UI library based on the user redux setting
  useEffect(() => {
    setHapticsEnabled(hapticsUserEnabled)
  }, [hapticsUserEnabled, setHapticsEnabled])

  useEffect(() => {
    Appearance.setColorScheme(themeSetting)
  }, [themeSetting])

  return (
    <>
      {/* <OfflineBanner /> */}
      <TestnetModeBanner />
      <AppStackNavigator />
      <StatusBar translucent backgroundColor="transparent" barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
    </>
  )
}
