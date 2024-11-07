export const SectionName = {
  HomeTab: 'home-tab',
  ExploreTab: 'explore-tab',
  MyTicketsTab: 'my-tickets-tab',
} as const

export type SectionNameType = (typeof SectionName)[keyof typeof SectionName]
