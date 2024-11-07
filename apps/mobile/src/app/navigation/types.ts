import { NativeStackScreenProps } from '@react-navigation/native-stack'
import { MobileScreens } from 'peach/src/types/screens/mobile'
import { HomeScreenTabIndex } from 'src/screens/HomeScreenTabIndex'

export type AppStackParamList = {
  [MobileScreens.Home]?: { tab?: HomeScreenTabIndex }
}

export type TabStackParamList = {
  Feed: undefined
  Explore: undefined
  MyTickets: undefined
}

export type AppStackScreenProp<Screen extends keyof AppStackParamList> = NativeStackScreenProps<
  AppStackParamList,
  Screen
>
