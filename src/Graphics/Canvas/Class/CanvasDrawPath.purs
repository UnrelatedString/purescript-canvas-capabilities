-- | Bindings for the
-- | [`CanvasDrawPath` interface mixin](https://html.spec.whatwg.org/multipage/canvas.html#canvasdrawpath)
-- | on `CanvasRenderingContext2D` and `OffscreenCanvasRenderingContext2D`.

module Graphics.Canvas.Class.CanvasDrawPath
  ( class CanvasDrawPath
  , class CanvasDrawOwnPath
  , beginPath
  , fill
  , stroke
  , clip
  , isPointInPath
  , isPointInStroke
  ) where

import Prelude

import Graphics.Canvas.Types
  ( CanvasFillRule
  , Point
  )

class CanvasDrawPath :: Type -> Type -> (Type -> Type) -> m
class CanvasDrawPath ctx path m where

  -- | Fill the path.
  fill :: ctx -> path -> CanvasFillRule -> m Unit

  -- | Stroke the path.
  stroke :: ctx -> path -> m Unit

  -- | Refine the clipping region to its intersection with the path.
  -- wow these interfaces REALLY suck at keeping stuff separate don't they
  -- but in this case it's at least kinda convenient
  clip :: ctx -> path -> CanvasFillRule -> m Unit

  isPointInPath :: ctx -> path -> Point -> CanvasFillRule -> m Boolean

  isPointInStroke :: ctx -> path -> Point -> m Boolean

-- | A separate class for the single member which only makes sense
-- | when using path data from the context itself.
class CanvasDrawPath ctx ctx m <= CanvasDrawOwnPath ctx m where

  -- | Clear all subpaths of the context.
  beginPath :: ctx -> m Unit
