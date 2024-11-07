import { Path, Svg } from 'react-native-svg'

// eslint-disable-next-line no-relative-import-paths/no-relative-import-paths
import { createIcon } from '../factories/createIcon'

export const [HomeFilled, AnimatedHomeFilled] = createIcon({
  name: 'HomeFilled',
  getIcon: (props) => (
    <Svg viewBox="0 0 22 22" fill="none" {...props}>
      <Path
        d="M8.5238 0.99594C9.35971 0.52688 10.1339 0.25 11 0.25C11.8661 0.25 12.6403 0.52688 13.4762 0.99594C14.2861 1.45043 15.2141 2.12145 16.3811 2.96522L17.8902 4.05633C18.8267 4.73347 19.5747 5.2743 20.1389 5.77487C20.7214 6.29173 21.1573 6.807 21.4337 7.45513C21.7107 8.10469 21.7777 8.77045 21.7406 9.5381C21.7047 10.2789 21.5674 11.1726 21.3961 12.2871L21.0808 14.3387C20.8374 15.9225 20.6436 17.1837 20.3589 18.1662C20.0645 19.1821 19.6498 19.9887 18.9086 20.6052C18.1704 21.2192 17.2911 21.4926 16.2169 21.6231C15.172 21.75 13.8538 21.75 12.1889 21.75H9.81112C8.14615 21.75 6.82799 21.75 5.78305 21.6231C4.7089 21.4926 3.82957 21.2192 3.0914 20.6052C2.35015 19.9887 1.93544 19.1821 1.64104 18.1662C1.35634 17.1836 1.16255 15.9225 0.919185 14.3387L0.603925 12.2872C0.432635 11.1727 0.295275 10.2789 0.259415 9.5381C0.222245 8.77045 0.289255 8.10469 0.566295 7.45513C0.842735 6.807 1.27854 6.29173 1.86109 5.77487C2.42528 5.27429 3.1733 4.73346 4.10983 4.05632L5.61887 2.96524C6.78586 2.12145 7.71389 1.45043 8.5238 0.99594ZM8.6143 15.2109C8.17848 14.8717 7.55017 14.95 7.21093 15.3858C6.87169 15.8216 6.94998 16.4499 7.38579 16.7892C8.36407 17.5507 9.63132 18 11 18C12.3687 18 13.636 17.5507 14.6143 16.7892C15.0501 16.4499 15.1284 15.8216 14.7891 15.3858C14.4499 14.95 13.8216 14.8717 13.3858 15.2109C12.765 15.6942 11.9318 16 11 16C10.0683 16 9.23512 15.6942 8.6143 15.2109Z"
        fill="currentColor"
        fillRule="evenodd"
        clipRule="evenodd"
      />
    </Svg>
  ),
})
