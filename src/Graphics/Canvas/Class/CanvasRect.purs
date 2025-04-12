-- | Bindings for the
-- | [`CanvasRect` interface mixin](https://html.spec.whatwg.org/multipage/canvas.html#canvasrect)
-- | on `CanvasRenderingContext2D`.

module Graphics.Canvas.Class.CanvasRect
  ( class CanvasRect
  , clearRect
  , fillRect
  , strokeRect
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried
  ( EffectFn2, runEffectFn2
  )
import Graphics.Canvas.Types
 ( Rect
 , CanvasRenderingContext2D
 )

class CanvasRect :: Type -> (Type -> Type) -> Constraint
class CanvasRect ctx m where

  -- | Erase all image data in the specified rectangle.
  -- | No-op if any coordinate or dimension is infinite or NaN.
  -- | Subject to clipping if applicable.
  clearRect :: ctx -> Rect -> m Unit

  -- | Fill the specified rectangle, with a fill style if applicable.
  -- | No-op if any coordinate or dimension is infinite or NaN.
  fillRect :: ctx -> Rect -> m Unit

  -- | Stroke the specified rectangle, with a stroke style if applicable.
  -- | No-op if any coordinate or dimension is infinite or NaN.
  strokeRect :: ctx -> Rect -> m Unit

foreign import clearRect_ :: EffectFn2 CanvasRenderingContext2D Rect Unit
foreign import fillRect_ :: EffectFn2 CanvasRenderingContext2D Rect Unit
foreign import strokeRect_ :: EffectFn2 CanvasRenderingContext2D Rect Unit

instance CanvasRect CanvasRenderingContext2D Effect where
  clearRect = runEffectFn2 clearRect_
  fillRect = runEffectFn2 fillRect_
  strokeRect = runEffectFn2 strokeRect_
