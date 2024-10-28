import { useCallback } from 'react'
import { ColorKeys } from 'ui/src/theme'
import { ExtractedColors, getExtractedColors } from 'ui/src/utils/colors/getExtractedColors'
import { useAsyncData } from 'utilities/src/react/hooks'
import { hex } from 'wcag-contrast'

export function useExtractedColors(
  imageUrl: Maybe<string>,
  fallback: ColorKeys = 'accent1',
  cache = true,
): { colors?: ExtractedColors; colorsLoading: boolean } {
  const getImageColors = useCallback(
    async () => getExtractedColors(imageUrl, fallback, cache),
    [imageUrl, fallback, cache],
  )

  const { data: colors, isLoading: colorsLoading } = useAsyncData(getImageColors)

  return { colors, colorsLoading }
}

export function passesContrast(color: string, backgroundColor: string, contrastThreshold: number): boolean {
  // sometimes the extracted colors come back as black or white, discard those
  if (!color || color === '#000000' || color === '#FFFFFF') {
    return false
  }

  const contrast = hex(color, backgroundColor)
  return contrast >= contrastThreshold
}
