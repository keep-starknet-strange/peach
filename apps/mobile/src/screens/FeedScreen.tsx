import { Flex, Text, useSporeColors } from 'ui/src'

export function FeedScreen(): JSX.Element {
  const colors = useSporeColors()

  return (
    <Flex style={{ backgroundColor: colors.accent1.val }}>
      <Text color="$neutral1">Home</Text>
    </Flex>
  )
}
