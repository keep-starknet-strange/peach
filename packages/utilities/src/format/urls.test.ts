import { formatDappURL, isGifUri, isSVGUri } from 'utilities/src/format/urls'

describe(isSVGUri, () => {
  it('detects svg', () => {
    expect(isSVGUri('http://test.com/x.svg')).toEqual(true)
  })
  it(`doesn't see http`, () => {
    expect(isSVGUri('http://test.com')).toEqual(false)
  })
  it('null and undefined handled the same way', () => {
    expect(isSVGUri(null)).toEqual(false)
    expect(isSVGUri(undefined)).toEqual(false)
  })
  it('returns true for an SVG URI with uppercase extension', () => {
    expect(isSVGUri('http://example.com/image.SVG')).toEqual(true)
  })

  it('returns false for a non-SVG URI', () => {
    expect(isSVGUri('http://example.com/image.png')).toEqual(false)
  })

  it('returns true for an SVG URI with query parameters', () => {
    expect(isSVGUri('http://example.com/image.svg?query=123')).toEqual(true)
  })

  it('returns true for an SVG URI with a fragment', () => {
    expect(isSVGUri('http://example.com/image.svg#fragment')).toEqual(true)
  })

  it('returns false for a URI that contains ".svg" but is not an SVG file', () => {
    expect(isSVGUri('http://example.com/.svg/image.png')).toEqual(false)
  })

  it('returns false for a URI ending with ".svg" in the path but is actually a directory', () => {
    expect(isSVGUri('http://example.com/assets/svg/')).toEqual(false)
  })

  it('returns false for an undefined URI', () => {
    expect(isSVGUri(undefined)).toEqual(false)
  })

  it('returns false for a null URI', () => {
    expect(isSVGUri(null)).toEqual(false)
  })

  it('handles invalid URIs gracefully', () => {
    expect(isSVGUri('http:///example.com:::image.svg')).toEqual(false)
  })

  it('returns false for an empty string', () => {
    expect(isSVGUri('')).toEqual(false)
  })

  it('returns false for a non-URI string that ends with ".svg"', () => {
    expect(isSVGUri('This is not a URI.svg')).toEqual(false)
  })
})

describe(isGifUri, () => {
  it('detects gif', () => {
    expect(isGifUri('http://test.com/x.gif')).toEqual(true)
  })
  it(`doesn't see http`, () => {
    expect(isGifUri('http://test.com')).toEqual(false)
  })
  it('null and undefined handled the same way', () => {
    expect(isGifUri(null)).toEqual(false)
    expect(isGifUri(undefined)).toEqual(false)
  })
  it('returns true for an GIF URI with uppercase extension', () => {
    expect(isGifUri('http://example.com/image.GIF')).toEqual(true)
  })

  it('returns false for a non-GIF URI', () => {
    expect(isGifUri('http://example.com/image.png')).toEqual(false)
  })

  it('returns true for an gif URI with query parameters', () => {
    expect(isGifUri('http://example.com/image.gif?query=123')).toEqual(true)
  })

  it('returns true for an gif URI with a fragment', () => {
    expect(isGifUri('http://example.com/image.gif#fragment')).toEqual(true)
  })

  it('returns false for a URI that contains ".gif" but is not an gif file', () => {
    expect(isGifUri('http://example.com/.gif/image.png')).toEqual(false)
  })

  it('returns false for a URI ending with ".gif" in the path but is actually a directory', () => {
    expect(isGifUri('http://example.com/assets/gif/')).toEqual(false)
  })

  it('returns false for an undefined URI', () => {
    expect(isGifUri(undefined)).toEqual(false)
  })

  it('returns false for a null URI', () => {
    expect(isGifUri(null)).toEqual(false)
  })

  it('handles invalid URIs gracefully', () => {
    expect(isGifUri('http:///example.com:::image.gif')).toEqual(false)
  })

  it('returns false for an empty string', () => {
    expect(isGifUri('')).toEqual(false)
  })

  it('returns false for a non-URI string that ends with ".gif"', () => {
    expect(isGifUri('This is not a URI.gif')).toEqual(false)
  })
})

describe(formatDappURL, () => {
  it('removes query params from url', () => {
    expect(formatDappURL('example.com?test=true')).toEqual('example.com')
    expect(formatDappURL('example.com?test=true&test2=false')).toEqual('example.com')
  })

  it('removes prefix from url', () => {
    expect(formatDappURL('https://example.com')).toEqual('example.com')
    expect(formatDappURL('https://www.example.com')).toEqual('example.com')
    expect(formatDappURL('www.example.com')).toEqual('example.com')
  })

  it('removes trailing slash from url', () => {
    expect(formatDappURL('example.com/')).toEqual('example.com')
  })

  it('does not remove http from url', () => {
    expect(formatDappURL('http://example.com')).toEqual('http://example.com')
  })
})
