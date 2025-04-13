-- | Bindings for the
-- | [`CanvasPath` interface mixin](https://html.spec.whatwg.org/multipage/canvas.html#canvaspath)
-- | on `CanvasRenderingContext2D` and `Path2D`.

module Graphics.Canvas.Class.CanvasPath
  ( class CanvasPath
  , closePath
  , moveTo
  , lineTo
  , quadraticCurveTo
  , bezierCurveTo
  , arcTo
  , rect
  , roundRect
  , arc
  , ellipse
  ) where

import Prelude
import Effect (Effect)
-- import Effect.Uncurried
--   ( 
--   )
import Graphics.Canvas.Types
  ( CanvasRenderingContext2D
  , Path2D
  , Point
  , Dimensions
  , ControlPoint
  , Angle
  , Rect
  , topLeft
  , topRight
  , bottomLeft
  , bottomRight
  , Radius
  , EllipseRadii
  , RectCorners
  , Interval
  )
import Unsafe.Coerce (unsafeCoerce)

class CanvasPath :: Type -> (Type -> Type) -> Constraint
class CanvasPath ctx m where

  -- | Close the current subpath with a straight line to its beginning,
  -- | and create a new subpath with the same beginning.
  -- | No-op if no subpath.
  closePath :: ctx -> m Unit

  -- | Create a new subpath from the given point.
  -- | No-op if any coordinate is infinite or NaN.
  moveTo :: ctx -> Point -> m Unit
  
  -- | Add the given point to the current subpath,
  -- | connected with a straight line.
  -- | Creates a new subpath from the given point if needed.
  -- | No-op if any coordinate or dimension is infinite or NaN.
  lineTo :: ctx -> Point -> m Unit

  -- | Add the given point to the current subpath,
  -- | connected with a quadratic Bézier curve using the given control point.
  -- | Creates a new subpath from the *control* point if needed.
  -- | No-op if any coordinate or dimension is infinite or NaN.
  quadraticCurveTo :: ctx -> ControlPoint -> Point -> m Unit

  -- | Add the given point to the current subpath,
  -- | connected with a cubic Bézier curve using the given control points.
  -- | Creates a new subpath from the *first control* point if needed.
  -- | No-op if any coordinate or dimension is infinite or NaN.
  bezierCurveTo :: ctx -> ControlPoint -> ControlPoint -> Point -> m Unit

  -- | Extend the current subpath by a circular arc defined by the
  -- | given control points and radius.
  -- | The name is something of a misnomer, as neither point given
  -- | is guaranteed to lie at the endpoint of the arc which is added
  -- | to the subpath, but the first control point is used directly
  -- | and connected to by a straight line in edge cases.
  -- | Creates a new subpath from the first control point if needed.
  -- | No-op if any coordinate or dimension is infinite or NaN.
  -- | Radius must be nonnegative.
  arcTo :: ctx -> ControlPoint -> ControlPoint -> Radius -> m Unit

  -- | Create a new closed subpath consisting of the given rectangle,
  -- | then create another new subpath at the rectangle's top left corner.
  -- | No-op if any coordinate or dimension is infinite or NaN.
  rect :: ctx -> Rect -> m Unit

  -- | Create a new closed subpath consisting of the specified rounded rectangle,
  -- | constructed by "carving" the corners of the rectangle into elliptic arcs
  -- | with the specified radii,
  -- | then create another new subpath at the given rectangle's top left corner
  -- | (which does not necessarily lie on the actual rounded rectangle).
  -- | No-op if any coordinate, dimension, or radius is infinite or NaN.
  -- | If any radii are too large, *all* radii are scaled down until there is no overlap.
  roundRect :: ctx -> Rect -> RoundRectRadii -> m Unit

  -- | Precisely equivalent to `ellipse` with major and minor radii equal
  -- | (and arbitrary finite rotation).
  arc :: ctx -> Point -> Radius -> Interval Angle -> Boolean

  -- | ughhhhhhhhhhhhhhhhhhhhh I need a break but I just want this to compiiiileeeeeeee
  ellipse :: ctx -> Point -> EllipseRadii -> Angle -> Interval Angle -> Boolean

-- | Implementation of `rect` using `moveTo`, `lineTo`, and `closePath`,
-- | in clockwise order as specified by the standard,
-- | for the convenience of non-foreign implementors (e.g. for mocking).
rectDefault :: forall ctx m. CanvasPath ctx m => Monad m => ctx -> Rect -> m Unit
rectDefault ctx r = do
  moveTo ctx $ topLeft r
  lineTo ctx $ topRight r
  lineTo ctx $ bottomRight r
  lineTo ctx $ bottomLeft r
  closePath ctx

type RoundRectRadii = RectCorners EllipseRadii

-- TODO: roundRectDefault, if I can figure out how to actually draw the desired elliptic arcs?
-- because. there's no actual methods in the API for elliptic arcs in and of themselves.
-- and it's impossible to represent ellipses exactly using Bézier curves.
-- and arcTo would be confusing enough even if it DID support ellipses.
-- and is it possible to like. apply a transform to a particular step in a subpath?? maybe???

-- | Internal helper type for representing the interface directly,
-- | so I can reuse the implementation for both JS types including it guilt-free.
foreign import data ICanvasPath :: Type

fromContext :: CanvasRenderingContext2D -> ICanvasPath
fromContext = unsafeCoerce

fromPath2D :: Path2D -> ICanvasPath
fromPath2D = unsafeCoerce


-- instance CanvasPath CanvasRenderingContext2D Effect where
--   arcTo = runEffectFn4 arcTo_ <<< fromContext

-- instance CanvasPath Path2D Effect where
--   arcTo = runEffectFn4 arcTo_ <<< fromPath2D
