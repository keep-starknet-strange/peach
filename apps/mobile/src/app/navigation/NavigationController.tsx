import { DefaultTheme, NavigationContainer as NativeNavigationContainer } from '@react-navigation/native'
import React, { FC, PropsWithChildren } from 'react'
import { useSporeColors } from 'ui/src'

export const NavigationContainer: FC<PropsWithChildren> = ({ children }: PropsWithChildren) => {
  const colors = useSporeColors()

  return (
    <NativeNavigationContainer
      // avoid white flickering background on screen navigation
      theme={{
        ...DefaultTheme,
        colors: { ...DefaultTheme.colors, background: colors.surface1.val },
      }}
    >
      {children}
    </NativeNavigationContainer>
  )
}
