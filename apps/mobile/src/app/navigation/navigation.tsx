import { createNativeStackNavigator } from '@react-navigation/native-stack'
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs'
import { MobileScreens } from 'peach/src/types/screens/mobile'
import { AppStackParamList, TabStackParamList } from 'src/app/navigation/types'
import React, { useCallback } from 'react'
import { FeedScreen } from 'src/screens/FeedScreen'
import { ExploreScreen } from 'src/screens/ExploreScreen'
import { MyTicketsScreen } from 'src/screens/MyTicketsScreen'
import { BlurView } from '@react-native-community/blur'
import { StyleSheet } from 'react-native'
import { TabIcon, TabIconProps } from 'src/components/layout/TabHelpers'
import { useSporeColors } from 'ui/src'

const AppStack = createNativeStackNavigator<AppStackParamList>()
const TabStack = createBottomTabNavigator<TabStackParamList>();

function TabStackNavigator(): JSX.Element {
  const renderTabBarBackground = useCallback(
    () => <BlurView
    // tint="light"
    // control the intensity of the blur effect
    blurAmount={20}
    style={{
      ...StyleSheet.absoluteFillObject,
      borderTopLeftRadius: 20,
      borderTopRightRadius: 20,
      // The overflow hidden is just to apply above radius.
      overflow: "hidden",
      // We can also apply background to tweak blur color
      backgroundColor: "transparent",
      // backgroundColor: "rgba(101, 92, 155, 0.4)",
    }}
  />,
    [],
  )

    const renderTabIcon = useCallback((props: TabIconProps) => {
    return <TabIcon {...props} />
  }, [])

  return (
    <TabStack.Navigator
    screenOptions={{
      headerShown: false,
      tabBarStyle: {
        // position absolute is required to extend the tab screens to also scroll behind the tab bar area,
        // so the blur effect would only work if there is some content showing behind it.
        position: "absolute",
        borderTopLeftRadius: 20,
        borderTopRightRadius: 20,
        shadowColor: "rgb(47, 64, 85)",
        shadowOffset: { width: 0, height: -4 },
        shadowOpacity: 0.12,
        shadowRadius: 16,
      },
      tabBarBackground: renderTabBarBackground,
    }}
       >
        <TabStack.Screen
        name="Feed"
        component={FeedScreen}
        options={{
          tabBarShowLabel: false,
          tabBarIcon: ({ focused }) => renderTabIcon({ focused, name: 'feed' }),
        }}
      />
      <TabStack.Screen
        name="Explore"
        component={ExploreScreen}
        options={{
          tabBarShowLabel: false,
          tabBarIcon: ({ focused }) => renderTabIcon({ focused, name: 'explore' }),
        }}
      />
      <TabStack.Screen
        name="MyTickets"
        component={MyTicketsScreen}
        options={{
          tabBarShowLabel: false,
          tabBarIcon: ({ focused }) => renderTabIcon({ focused, name: 'tickets' }),
        }}
      />
       </TabStack.Navigator>
  )
}

export function AppStackNavigator(): JSX.Element {
  const colors = useSporeColors()

  return (
    <AppStack.Navigator
      screenOptions={{
        ...navOptions.noHeader,
        fullScreenGestureEnabled: true,
        gestureEnabled: true,
        contentStyle: { backgroundColor: colors.accent1.val },
      }}
    >
      <AppStack.Screen component={TabStackNavigator} name={MobileScreens.Home} />
    </AppStack.Navigator>
  )
}

const navOptions = {
  noHeader: { headerShown: false },
  presentationModal: { presentation: 'modal' },
} as const
