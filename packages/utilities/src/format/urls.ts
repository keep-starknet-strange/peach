export function isSegmentUri(uri: Maybe<string>, extension: string): boolean {
  if (typeof uri !== 'string' || !uri.trim()) {
    return false
  }

  try {
    // Validate URI structure by checking for presence of scheme
    if (!/^https?:\/\/.+/i.test(uri)) {
      return false
    }

    const url = new URL(uri)
    const pathname = url.pathname

    // Check if pathname ends with an '.svg' (or other) extension, case-insensitive
    return pathname.toLowerCase().endsWith(extension)
  } catch {
    // URI parsing failed, indicating an invalid URI
    return false
  }
}

/**
 * Checks if the provided URI points to an SVG file.
 *
 * This examines the path of a URI to determine if it ends with an ".svg" extension,
 * accounting for potential query parameters or anchors. The check is case-insensitive.
 *
 * @param {Maybe<string>} uri The URI to check.
 * @returns {boolean} True if the URI points to an SVG file, false otherwise.
 */
export function isSVGUri(uri: Maybe<string>): boolean {
  return isSegmentUri(uri, '.svg')
}

/**
 * Checks if the provided URI points to a GIF file.
 *
 * This examines the path of a URI to determine if it ends with an ".gif" extension,
 * accounting for potential query parameters or anchors. The check is case-insensitive.
 *
 * @param {Maybe<string>} uri The URI to check.
 * @returns {boolean} True if the URI points to an GIF file, false otherwise.
 */
export function isGifUri(uri: Maybe<string>): boolean {
  return isSegmentUri(uri, '.gif')
}

function truncateQueryParams(url: string): string {
  // In fact, the first element will be always returned below. url is
  // added as a fallback just to satisfy TypeScript.
  return url.split('?')[0] ?? url
}

/**
 * Removes query params, safe prefixes and trailing slashes from URL to improve human readability.
 *
 * @param {string} url The URL to check.
 */
export function formatDappURL(url: string): string {
  const truncatedURL = truncateQueryParams(url)

  return truncatedURL?.replace('https://', '').replace('www.', '').replace(/\/$/, '')
}
