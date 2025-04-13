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
  , RoundRectRadii
  , rectDefault
  ) where

import Prelude

import Data.Semigroup.Foldable (foldMap1)
import Effect (Effect)
import Effect.Uncurried
  ( EffectFn1, runEffectFn1
  , EffectFn2, runEffectFn2
  , EffectFn3, runEffectFn3
  , EffectFn4, runEffectFn4
  , EffectFn5, runEffectFn5
  , EffectFn6, runEffectFn6
  )
import Graphics.Canvas.Types
  ( CanvasRenderingContext2D
  , Path2D
  , Point
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
  -- | (and arbitrary finite rotation), adding a circular arc to the subpath.
  arc :: ctx -> Point -> Radius -> Interval Angle -> Boolean -> m Unit

  -- | ughhhhhhhhhhhhhhhhhhhhh I need a break but I just want this to compiiiileeeeeeee
  ellipse :: ctx -> Point -> EllipseRadii -> Angle -> Interval Angle -> Boolean -> m Unit

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

-- | Always constructed with length 4. Never ever exposed because this is a mess and I hate it
type ForeignRoundRectRadii = Array { x :: Radius, y :: Radius }

-- lmao I didn't even check that the array was clockwise before I wrote the whole Foldable instance
translateRRR :: RoundRectRadii -> ForeignRoundRectRadii
translateRRR = foldMap1 \{ semiMajor, semiMinor } -> [{ x: semiMajor, y: semiMinor }]

-- TODO: roundRectDefault, if I can figure out how to actually draw the desired elliptic arcs?
-- which would I guess have to use start and end angles with ellipse ;_;

-- | Internal helper type for representing the interface directly,
-- | so I can reuse the implementation for both JS types including it guilt-free.
foreign import data ICanvasPath :: Type

fromContext :: CanvasRenderingContext2D -> ICanvasPath
fromContext = unsafeCoerce

fromPath2D :: Path2D -> ICanvasPath
fromPath2D = unsafeCoerce

foreign import closePath_ :: EffectFn1 ICanvasPath Unit
foreign import moveTo_ :: EffectFn2 ICanvasPath Point Unit
foreign import lineTo_ :: EffectFn2 ICanvasPath Point Unit
foreign import quadraticCurveTo_ :: EffectFn3 ICanvasPath ControlPoint Point Unit
foreign import bezierCurveTo_ :: EffectFn4 ICanvasPath ControlPoint ControlPoint Point Unit
foreign import arcTo_ :: EffectFn4 ICanvasPath ControlPoint ControlPoint Radius Unit
foreign import rect_ :: EffectFn2 ICanvasPath Rect Unit
foreign import roundRect_ :: EffectFn3 ICanvasPath Rect ForeignRoundRectRadii Unit
foreign import arc_ :: EffectFn5 ICanvasPath Point Radius (Interval Angle) Boolean Unit
foreign import ellipse_ :: EffectFn6 ICanvasPath Point EllipseRadii Angle (Interval Angle) Boolean Unit

roundRectImpl :: ICanvasPath -> Rect -> RoundRectRadii -> Effect Unit
roundRectImpl i r = runEffectFn3 roundRect_ i r <<< translateRRR

instance CanvasPath CanvasRenderingContext2D Effect where
  closePath = runEffectFn1 closePath_ <<< fromContext
  moveTo = runEffectFn2 moveTo_ <<< fromContext
  lineTo = runEffectFn2 lineTo_ <<< fromContext
  quadraticCurveTo = runEffectFn3 quadraticCurveTo_ <<< fromContext
  bezierCurveTo = runEffectFn4 bezierCurveTo_ <<< fromContext
  arcTo = runEffectFn4 arcTo_ <<< fromContext
  rect = runEffectFn2 rect_ <<< fromContext
  roundRect = roundRectImpl <<< fromContext
  arc = runEffectFn5 arc_ <<< fromContext
  ellipse = runEffectFn6 ellipse_ <<< fromContext

instance CanvasPath Path2D Effect where
  closePath = runEffectFn1 closePath_ <<< fromPath2D
  moveTo = runEffectFn2 moveTo_ <<< fromPath2D
  lineTo = runEffectFn2 lineTo_ <<< fromPath2D
  quadraticCurveTo = runEffectFn3 quadraticCurveTo_ <<< fromPath2D
  bezierCurveTo = runEffectFn4 bezierCurveTo_ <<< fromPath2D
  arcTo = runEffectFn4 arcTo_ <<< fromPath2D
  rect = runEffectFn2 rect_ <<< fromPath2D
  roundRect = roundRectImpl <<< fromPath2D
  arc = runEffectFn5 arc_ <<< fromPath2D
  ellipse = runEffectFn6 ellipse_ <<< fromPath2D
