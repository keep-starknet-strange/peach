import React from 'react'
import { Platform, StyleSheet } from 'react-native'
import { GeneratedIcon } from 'ui/src'
import { Home } from 'ui/src/components/icons/Home'
import { HomeFilled } from 'ui/src/components/icons/HomeFilled'
import { colorsLight, spacing } from 'ui/src/theme'

export const TAB_BAR_HEIGHT = 56

export const TAB_STYLES = StyleSheet.create({
  blurContainer: {
    bottom: 0,
    left: 0,
    position: 'absolute',
    right: 0,
  },
  container: {
    flex: 1,
    overflow: 'hidden',
  },
  tabBar: {
    backgroundColor: Platform.select({
      // Semi-transparent instead of fully transparent
      ios: 'rgba(255, 255, 255, 0.8)',
      android: colorsLight.surface1,
    }),
    borderBottomColor: colorsLight.surface3,
    // Position at bottom
    bottom: 0,
    left: 0,
    paddingLeft: spacing.spacing12,
    // Make sure this is here
    position: 'absolute',
    right: 0,
    // Ensure it's above other content
    zIndex: 1000,
  },
})

export const Icons: Record<string, { default: GeneratedIcon; focused: GeneratedIcon }> = {
  home: {
    default: Home,
    focused: HomeFilled,
  },
}

export type TabIconName = 'feed' | 'explore' | 'tickets'

export type TabIconProps = {
  name: TabIconName
  focused: boolean
}

export const TabIcon = ({ name, focused }: TabIconProps): JSX.Element | null => {
  switch (name) {
    case 'feed':
      return focused ? <HomeFilled color="$accent" size={20} /> : <Home color="$accent" size={20} />
    case 'explore':
      return focused ? <HomeFilled size={20} /> : <Home size={20} />
    case 'tickets':
      return focused ? <HomeFilled size={20} /> : <Home size={20} />
    default:
      return null
  }
}
