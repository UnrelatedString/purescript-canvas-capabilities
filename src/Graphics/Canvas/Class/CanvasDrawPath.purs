-- | Bindings for the
-- | [`CanvasDrawPath` interface mixin](https://html.spec.whatwg.org/multipage/canvas.html#canvasdrawpath)
-- | on `CanvasRenderingContext2D` and `OffscreenCanvasRenderingContext2D`.

module Graphics.Canvas.Class.CanvasDrawPath
  ( class CanvasDrawPath
  , class CanvasDrawOwnPath
  , beginPath
  , fill
  , fill'
  , stroke
  , stroke'
  , clip
  , clip'
  , isPointInPath
  , isPointInPath'
  , isPointInStroke
  , isPointInStroke'
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried
  ( EffectFn1, runEffectFn1
  , EffectFn2, runEffectFn2
  , EffectFn3, runEffectFn3
  , EffectFn4, runEffectFn4
  )
import Graphics.Canvas.Types
  ( CanvasFillRule
  , Point
  , CanvasRenderingContext2D
  , OffscreenCanvasRenderingContext2D
  , Path2D
  )
import Unsafe.Coerce (unsafeCoerce)

class CanvasDrawPath :: Type -> Type -> (Type -> Type) -> Constraint
class CanvasDrawPath ctx path m where

  -- | Fill the path.
  fill :: ctx -> path -> CanvasFillRule -> m Unit

  -- | Stroke the path.
  stroke :: ctx -> path -> m Unit

  -- | Refine the clipping region to its intersection with the path.
  -- wow these interfaces REALLY suck at keeping stuff separate don't they
  -- but in this case it's at least kinda convenient
  clip :: ctx -> path -> CanvasFillRule -> m Unit

  isPointInPath :: ctx -> path -> CanvasFillRule -> Point -> m Boolean

  isPointInStroke :: ctx -> path -> Point -> m Boolean

-- | A separate class for the single member which only makes sense
-- | when using path data from the context itself.
class CanvasDrawPath ctx Unit m <= CanvasDrawOwnPath ctx m where

  -- | Clear all subpaths of the context.
  beginPath :: ctx -> m Unit

fill' :: forall ctx m. CanvasDrawPath ctx Unit m => ctx -> CanvasFillRule -> m Unit
fill' = flip fill unit

stroke' :: forall ctx m. CanvasDrawPath ctx Unit m => ctx -> m Unit
stroke' = flip stroke unit

clip' :: forall ctx m. CanvasDrawPath ctx Unit m => ctx -> CanvasFillRule -> m Unit
clip' = flip clip unit

isPointInPath' :: forall ctx m. CanvasDrawPath ctx Unit m => ctx -> CanvasFillRule -> Point -> m Boolean
isPointInPath' = flip isPointInPath unit

isPointInStroke' :: forall ctx m. CanvasDrawPath ctx Unit m => ctx -> Point -> m Boolean
isPointInStroke' = flip isPointInStroke unit

-- | for cheeky splatting :p
type ForeignMaybePath = Array Path2D

foreign import data ICanvasDrawPath :: Type

fromContext :: CanvasRenderingContext2D -> ICanvasDrawPath
fromContext = unsafeCoerce

fromOffscreen :: OffscreenCanvasRenderingContext2D -> ICanvasDrawPath
fromOffscreen = unsafeCoerce

foreign import beginPath_ :: EffectFn1 ICanvasDrawPath Unit
foreign import fill_ :: EffectFn3 ForeignMaybePath ICanvasDrawPath String Unit
foreign import stroke_ :: EffectFn2 ForeignMaybePath ICanvasDrawPath Unit
foreign import clip_ :: EffectFn3 ForeignMaybePath ICanvasDrawPath String Unit
foreign import isPointInPath_ :: EffectFn4 ForeignMaybePath ICanvasDrawPath String Point Boolean
foreign import isPointInStroke_ :: EffectFn3 ForeignMaybePath ICanvasDrawPath Point Boolean

instance CanvasDrawPath CanvasRenderingContext2D Unit Effect where
  fill ctx _ = runEffectFn3 fill_ [] (fromContext ctx) <<< show
  stroke ctx _ = runEffectFn2 stroke_ [] $ fromContext ctx
  clip ctx _ = runEffectFn3 clip_ [] (fromContext ctx) <<< show
  isPointInPath ctx _ = runEffectFn4 isPointInPath_ [] (fromContext ctx) <<< show
  isPointInStroke ctx _ = runEffectFn3 isPointInStroke_ [] $ fromContext ctx

instance CanvasDrawOwnPath CanvasRenderingContext2D Effect where
  beginPath = runEffectFn1 beginPath_ <<< fromContext

instance CanvasDrawPath CanvasRenderingContext2D Path2D Effect where
  fill ctx path = runEffectFn3 fill_ [path] (fromContext ctx) <<< show
  stroke ctx path = runEffectFn2 stroke_ [path] $ fromContext ctx
  clip ctx path = runEffectFn3 clip_ [path] (fromContext ctx) <<< show
  isPointInPath ctx path = runEffectFn4 isPointInPath_ [path] (fromContext ctx) <<< show
  isPointInStroke ctx path = runEffectFn3 isPointInStroke_ [path] $ fromContext ctx

instance CanvasDrawPath OffscreenCanvasRenderingContext2D Unit Effect where
  fill ctx _ = runEffectFn3 fill_ [] (fromOffscreen ctx) <<< show
  stroke ctx _ = runEffectFn2 stroke_ [] $ fromOffscreen ctx
  clip ctx _ = runEffectFn3 clip_ [] (fromOffscreen ctx) <<< show
  isPointInPath ctx _ = runEffectFn4 isPointInPath_ [] (fromOffscreen ctx) <<< show
  isPointInStroke ctx _ = runEffectFn3 isPointInStroke_ [] $ fromOffscreen ctx

instance CanvasDrawOwnPath OffscreenCanvasRenderingContext2D Effect where
  beginPath = runEffectFn1 beginPath_ <<< fromOffscreen

instance CanvasDrawPath OffscreenCanvasRenderingContext2D Path2D Effect where
  fill ctx path = runEffectFn3 fill_ [path] (fromOffscreen ctx) <<< show
  stroke ctx path = runEffectFn2 stroke_ [path] $ fromOffscreen ctx
  clip ctx path = runEffectFn3 clip_ [path] (fromOffscreen ctx) <<< show
  isPointInPath ctx path = runEffectFn4 isPointInPath_ [path] (fromOffscreen ctx) <<< show
  isPointInStroke ctx path = runEffectFn3 isPointInStroke_ [path] $ fromOffscreen ctx
