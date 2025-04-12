-- | Bindings for the
-- | [`CanvasRect` interface mixin](https://html.spec.whatwg.org/multipage/canvas.html#canvasrect)
-- | on `CanvasRenderingContext2D`.

module Graphics.Canvas.Class.CanvasRect
  ( class CanvasRect
  , clearRect
  ) where

import Prelude

import Effect (Effect)
import Graphics.Canvas.Types
 ( Rectangle
 )

class CanvasRect :: Type -> (Type -> Type) -> Constraint
class CanvasRect ctx m where
  clearRect :: ctx -> Rectangle Number -> m Unit
