// import { useIsFocused } from '@react-navigation/native'
// import { SectionName, SectionNameType } from 'peach/src/features/telemetry/constants'
// import { MobileScreens } from 'peach/src/types/screens/mobile'
// import React, { useCallback, useEffect, useMemo, useState } from 'react'
// import { Freeze } from 'react-freeze'
// import { View } from 'react-native'
// import Animated, { FadeIn } from 'react-native-reanimated'
// import { SceneRendererProps, TabBar, TabView } from 'react-native-tab-view'
// import { AppStackScreenProp } from 'src/app/navigation/types'
// import { ExploreTabScreen } from 'src/screens/ExploreScreen'
// import { HomeTabScreen } from 'src/screens/FeedScreen'
// import { MyTicketsTabScreen } from 'src/screens/MyTicketsScreen'
// import { Screen } from 'src/components/layout/Screen'
// import { TAB_STYLES, TabIcon, TabIconName } from 'src/components/layout/TabHelpers'
// import { HomeScreenTabIndex } from 'src/screens/HomeScreenTabIndex'
// import { useHapticFeedback, useSporeColors } from 'ui/src'
// import { useDeviceDimensions } from 'ui/src/hooks/useDeviceDimensions'
// import { spacing } from 'ui/src/theme'
// import noop from 'utilities/src/react/noop'
// import { BlurView } from '@react-native-community/blur'

// type HomeRoute = {
//   key: (typeof SectionName)[keyof typeof SectionName]
//   title: string
//   icon: TabIconName
// }

// export function HomeScreen(props?: AppStackScreenProp<MobileScreens.Home>): JSX.Element {
//   const colors = useSporeColors()
//   const dimensions = useDeviceDimensions()
//   const { hapticFeedback } = useHapticFeedback()
//   const isFocused = useIsFocused()
//   const isHomeScreenBlur = !isFocused // TODO: add modal support

//   const [routeTabIndex, setRouteTabIndex] = useState(props?.route?.params?.tab ?? HomeScreenTabIndex.Feed)
//   // Ensures that tabIndex has the proper value between the empty state and non-empty state
//   const tabIndex = routeTabIndex

//   useEffect(
//     function syncTabIndex() {
//       const newTabIndex = props?.route.params?.tab
//       if (newTabIndex === undefined) {
//         return
//       }
//       setRouteTabIndex(newTabIndex)
//     },
//     [props?.route.params?.tab],
//   )

//   const routes = useMemo(
//     (): HomeRoute[] => [
//       { key: SectionName.HomeTab, icon: 'feed', title: 'Home' },
//       { key: SectionName.ExploreTab, icon: 'explore', title: 'Explore' },
//       { key: SectionName.MyTicketsTab, icon: 'tickets', title: 'My Tickets' },
//     ],
//     [],
//   )

//   const renderTabIcon = useCallback(({ route, focused }: { route: HomeRoute; focused: boolean }) => {
//     return <TabIcon focused={focused} name={route.icon} />
//   }, [])

//   const renderTabBar = useCallback(
//     (sceneProps: SceneRendererProps) => {
//       return (

//   <BlurView
//   style={TAB_STYLES.blurContainer}
//   blurType="light"
//   blurAmount={20}>
//         <TabBar
//           {...sceneProps}
//           navigationState={{ index: tabIndex, routes }}
//           pressColor="transparent" // Android only
//           renderIcon={renderTabIcon}
//           renderIndicator={noop}
//           style={[
//             TAB_STYLES.tabBar,
//             {
//               backgroundColor: colors.surface1.get(),
//               borderBottomColor: colors.surface3.get(),
//               paddingLeft: spacing.spacing12,
//             },
//           ]}
//           renderLabel={noop}
//           tabStyle={{ width: 'auto' }}
//           onTabPress={async (): Promise<void> => {
//             await hapticFeedback.impact()
//           }}
//         />
//   </BlurView>
//       )
//     },
//     [tabIndex, routes, renderTabIcon, colors.surface1, colors.surface3, hapticFeedback],
//   )

//   const renderTab = useCallback(
//     ({
//       route,
//     }: {
//       route: {
//         key: SectionNameType
//         title: string
//       }
//     }) => {
//       switch (route?.key) {
//         case SectionName.HomeTab:
//           return (
//             <Freeze freeze={tabIndex !== 0 && isHomeScreenBlur}>
//               <Animated.View entering={FadeIn}>
//                 <HomeTabScreen />
//               </Animated.View>
//             </Freeze>
//           )
//         case SectionName.ExploreTab:
//           return (
//             <Freeze freeze={tabIndex !== 1 && isHomeScreenBlur}>
//               <ExploreTabScreen />
//             </Freeze>
//           )
//         case SectionName.MyTicketsTab:
//           return (
//             <Freeze freeze={tabIndex !== 2 && isHomeScreenBlur}>
//               <MyTicketsTabScreen />
//             </Freeze>
//           )
//       }
//       return null
//     },
//     [tabIndex, isHomeScreenBlur],
//   )

//   return (
//     <Screen edges={['left', 'right']}>
//       <View style={TAB_STYLES.container}>
//         <TabView
//           lazy
//           swipeEnabled={false}
//           animationEnabled={false}
//           initialLayout={{
//             height: dimensions.fullHeight,
//             width: dimensions.fullWidth,
//           }}
//           navigationState={{ index: tabIndex, routes }}
//           renderScene={renderTab}
//           renderTabBar={renderTabBar}
//           // screenName={MobileScreens.Home}
//           onIndexChange={setRouteTabIndex}
//         />
//       </View>
//       {/* <NavBar /> */}
//     </Screen>
//   )
// }
