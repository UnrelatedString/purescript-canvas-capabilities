# purescript-canvas-capabilities

[![CI](https://github.com/UnrelatedString/purescript-canvas-capabilities/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/UnrelatedString/purescript-canvas-capabilities/actions/workflows/ci.yml)
![Latest Version Tag](https://img.shields.io/github/v/tag/UnrelatedString/purescript-canvas-capabilities)
[![Pursuit](https://pursuit.purescript.org/packages/purescript-canvas-capabilities/badge?)](https://pursuit.purescript.org/packages/purescript-canvas-capabilities)


Bindings to the Canvas API, in the form of fine-grained "capability" classes, allowing easier mocking and porting, and reducing the mental load of using the Canvas API directly. Improving the ergonomics of the API itself is out of scope; see `massara-na-canvas` or any of the myriad JS libraries made for that purpose. Maintained independently from and not interoperable with the `canvas` package, but things should `unsafeCoerce` back and forth well enough if you really want them to, and uses other existing web bindings whenever possible.

Note that in all documentation of class members, edge case handling is specified as if prescriptive for all instances, but should not be interpreted as such. No user code should rely on such edge cases unless specifically intended to emulate the nitty-gritty of the Canvas API. Anyone writing instances other than the normative `Effect` instances should feel free to handle edge cases however they wish.

## Installation

```
spago install canvas-capabilities
```

## Documentation

Documentation is published [on Pursuit](https://pursuit.purescript.org/packages/purescript-canvas-capabilities).

## Coverage

### `HTMLCanvasElement`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement#specifications) [Pursuit](https://pursuit.purescript.org/packages/purescript-canvas/6.0.0/docs/Graphics.Canvas#t:CanvasElement)

- [ ] width
- [ ] height
- [ ] getContext
- [ ] toDataURL
- [ ] toBlob
- [ ] transferControlToOffscreen

### `CanvasRenderingContext2D`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D#specifications) [Pursuit](https://pursuit.purescript.org/packages/purescript-canvas/6.0.0/docs/Graphics.Canvas#t:Context2D)

#### mixin interface `CanvasSettings`

- [ ] getContextAttributes

#### mixin interface `CanvasState`

- [ ] save
- [ ] restore
- [ ] reset
- [ ] isContextLost

#### mixin interface `CanvasTransform`

- [ ] scale
- [ ] rotate
- [ ] translate
- [ ] transform
- [ ] getTransform
- [ ] setTransform
- [ ] resetTransform

#### mixin interface `CanvasCompositing`

- [ ] globalAlpha
- [ ] globalCompositeOperation

#### mixin interface `CanvasImageSmoothing`

- [ ] imageSmoothingEnabled
- [ ] imageSmoothingQuality

#### mixin interface `CanvasFillStrokeStyles`

- [ ] strokeStyle
  - [ ] DOMString
  - [ ] CanvasGradient
  - [ ] CanvasPattern
- [ ] fillStyle
  - [ ] DOMString
  - [ ] CanvasGradient
  - [ ] CanvasPattern
- [ ] createLinearGradient
- [ ] createRadialGradient
- [ ] createConicGradient
- [ ] createPattern

#### mixin interface `CanvasShadowStyles`

- [ ] shadowOffsetX
- [ ] shadowOffsetY
- [ ] shadowBlur
- [ ] shadowColor

#### mixin interface `CanvasFilters`

- [ ] filter

#### mixin interface `CanvasRect`

- [ ] clearRect
- [ ] fillRect
- [ ] strokeRect

#### mixin interface `CanvasDrawPath`

- [ ] beginPath
- [ ] fill
- [ ] stroke
- [ ] clip
- [ ] isPointInPath
- [ ] isPointInStroke

#### mixin interface `CanvasUserInterface`

- [ ] drawFocusIfNeeded

#### mixin interface `CanvasText`

- [ ] fillText
- [ ] strokeText
- [ ] measureText

#### mixin interface `CanvasDrawImage`

- [ ] drawImage
  - [ ] dx, dy
  - [ ] sx, sy

#### mixin interface `CanvasImageData`

- [ ] createImageData
- [ ] getImageData
- [ ] putImageData

#### mixin interface `CanvasPathDrawingStyles`

- [ ] lineWidth
- [ ] lineCap
- [ ] lineJoin
- [ ] miterLimit

#### mixin interface `CanvasTextDrawingStyles`

- [ ] lang
- [ ] font
- [ ] textAlign
- [ ] textBaseline
- [ ] direction
- [ ] letterSpacing
- [ ] fontKerning
- [ ] fontStretch
- [ ] fontVariantCaps
- [ ] textRendering
- [ ] wordSpacing

#### mixin interface `CanvasPath`

- [ ] closePath
- [ ] moveTo
- [ ] lineTo
- [ ] quadraticCurveTo
- [ ] bezierCurveTo
- [ ] arcTo
- [ ] rect
- [ ] roundRect
- [ ] arc
- [ ] ellipse

### `CanvasGradient`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/CanvasGradient#specifications) [Pursuit](https://pursuit.purescript.org/packages/purescript-canvas/6.0.0/docs/Graphics.Canvas#t:CanvasGradient)

- [ ] addColorStop

### `CanvasPattern`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/CanvasPattern#specifications) [Pursuit](https://pursuit.purescript.org/packages/purescript-canvas/6.0.0/docs/Graphics.Canvas#t:CanvasPattern)

- [ ] setTransform

### `ImageBitmap`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/ImageBitmap#specifications) (not in `purescript-canvas`)

(low priority)


### `ImageData`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/ImageData#specifications) [Pursuit](https://pursuit.purescript.org/packages/purescript-canvas/6.0.0/docs/Graphics.Canvas#t:ImageData)

- [ ] constructor
- [ ] width
- [ ] height
- [ ] data
- [ ] colorSpace

### `TextMetrics`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/TextMetrics#specifications) [Pursuit](https://pursuit.purescript.org/packages/purescript-canvas/6.0.0/docs/Graphics.Canvas#t:TextMetrics)

- [ ] width
- [ ] actualBoundingBoxLeft
- [ ] actualBoundingBoxRight
- [ ] fontBoundingBoxAscent
- [ ] fontBoundingBoxDescent
- [ ] actualBoundingBoxAscent
- [ ] actualBoundingBoxDescent
- [ ] emHeightAscent
- [ ] emHeightDescent
- [ ] hangingBaseline
- [ ] alphabeticBaseline
- [ ] ideographicBaseline

### `OffscreenCanvas`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/OffscreenCanvas#specifications) (not in `purescript-canvas`, yet)

- [ ] constructor
- [ ] width
- [ ] height
- [ ] transferToImageBitmap
- [ ] convertToBlob

### `Path2D`

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/OffscreenCanvas#specifications) (not in `purescript-canvas`)

- [ ] constructor
- [ ] addPath

The above Canvas API listing is adapted from ["Canvas API"](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) by Mozilla Contributors, licensed under CC-BY-SA 2.5, and from [the HTML Living Standard](https://html.spec.whatwg.org/multipage/canvas.html) by WHATWG, licensed under CC-BY 4.0. Note to self: include similar attribution [according to such guidelines](https://developer.mozilla.org/en-US/docs/MDN/Writing_guidelines/Attrib_copyright_license) when writing my own docs!
