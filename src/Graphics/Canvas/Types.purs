module Graphics.Canvas.Types
  ( module Reexports
  , CanvasRenderingContext2D
  , OffscreenCanvasRenderingContext2D
  , Path2D
  , TextAlign
  , TextMetrics
  , realTextBoundingBox
  , Point
  , Dimensions
  , Rect
  , rectangle
  , topLeft
  , topRight
  , bottomLeft
  , bottomRight
  , area
  , ControlPoint(..)
  , Radius(..)
  , radius
  , EllipseRadii
  , zeroEccentricity
  , Angle(..)
  , degrees
  , tauOver
  , RectCorners(..)
  , Interval(..)
  , CanvasFillRule
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Foldable (class Foldable)
import Data.Semigroup.Foldable (class Foldable1)
import Data.Number (tau)

import Web.HTML.HTMLCanvasElement (HTMLCanvasElement) as Reexports

foreign import data CanvasRenderingContext2D :: Type

foreign import data OffscreenCanvasRenderingContext2D :: Type

foreign import data Path2D :: Type

-- | Possible text alignment modes. Locale-dependent start alignment is the default.
data TextAlign =
    LeftAlign
  | RightAlign
  | CenteredAlign
  | LocaleStartAlign
  | LocaleEndAlign

-- | [The `TextMetrics` interface.](https://html.spec.whatwg.org/multipage/canvas.html#textmetrics)
-- wait shoutld this use CSSPixels from dom-indexed or ??? ughhh yeah wait uhhh . fuck. because like for canvas internal use it's like maybe more convenient BUIT also semantically they're CSS pixels and a. wait what. are they always strictly going to be ints even if you render them at weird offse wait that doesn't even matter uhhhh yeah i guess it does make sense they'd always be ints vut then doesn't the standard have a way to say that or ????????????
type TextMetrics =
  { width :: Number
  , actualBoundingBoxLeft :: Number
  , actualBoundingBoxRight :: Number
  , fontBoundingBoxAscent :: Number
  , fontBoundingBoxDescent :: Number
  , actualBoundingBoxAscent :: Number
  , actualBoundingBoxDescent :: Number
  , emHeightAscent :: Number
  , emHeightDescent :: Number
  , hangingBaseline :: Number
  , alphabeticBaseline :: Number
  , ideographicBaseline :: Number
  }

-- | Predict the bounding box of text from `TextMetrics` if rendered at a given `Point`,
-- | assuming the rendering is done with the same settings.
realTextBoundingBox :: TextMetrics -> Point -> Rect
realTextBoundingBox
    { actualBoundingBoxLeft, actualBoundingBoxRight
    , actualBoundingBoxAscent, actualBoundingBoxDescent
    }
    { x, y }
  =
    { x: x - actualBoundingBoxLeft
    , y: y - actualBoundingBoxAscent
    , w: actualBoundingBoxLeft + actualBoundingBoxRight
    , h: actualBoundingBoxAscent + actualBoundingBoxDescent
    }

-- | A point on the canvas.
type Point =
  { x :: Number
  , y :: Number
  }

-- | The dimensions of a rectangular area, such as the canvas itself.
type Dimensions =
  { w :: Number
  , h :: Number
  }

-- | A rectangle on the canvas, represented as its top left corner and its dimensions.
-- | Defined as a flat record for convenience; this is guaranteed to be stable for FFI use.
-- | Dimensions are assumed to be positive, but may nevertheless be well-behaved if negative.
type Rect =
  { x :: Number
  , y :: Number
  , w :: Number
  , h :: Number
  }

-- | Compose a `Point` and `Dimensions` into a `Rect`.
rectangle :: Point -> Dimensions -> Rect 
rectangle {x, y} {h, w} = {x, y, h, w}

-- | Get the top left corner of a `Rect`.
topLeft :: Rect -> Point 
topLeft {x, y} = {x, y}

-- | Get the top right corner of a `Rect`.
topRight :: Rect -> Point 
topRight {x, y, w} = {x: x + w, y}

-- | Get the bottom left corner of a `Rect`.
bottomLeft :: Rect -> Point 
bottomLeft {x, y, h} = {x, y: y + h}

-- | Get the bottom right corner of a `Rect`.
bottomRight :: Rect -> Point 
bottomRight {x, y, w, h} = {x: x + w, y: y + h}

-- | Get the area of a `Rect` or `Dimensions`.
area :: forall r. { w :: Number, h :: Number | r} -> Number
area {w, h} = w * h

-- | Control points for Bézier curves and other such shapes,
-- | as a newtype to make types more self-documenting in lieu of spec records.
newtype ControlPoint = ControlPoint Point

-- | The radius of a circle or a radius of an ellipse.
-- | Assumed to be nonnegative; the Canvas API typically throws an error
-- | when a negative radius is given!
newtype Radius = Radius Number

-- | Opt-in validating smart constructor for `Radius`,
-- | giving `Nothing` if the given number is negative (not including negative zero).
radius :: Number -> Maybe Radius
radius n
  | n < 0.0 = Nothing
  | otherwise = Just $ Radius n

-- | The semi-major and semi-minor axes of an ellipse,
-- | identified with the x and y dimensions if not rotated.
type EllipseRadii =
  { semiMajor :: Radius
  , semiMinor :: Radius
  }

-- | Construct `EllipseRadii` describing a circle of the given radius.
zeroEccentricity :: Radius -> EllipseRadii
zeroEccentricity r = { semiMajor: r, semiMinor: r }

-- | An angle in radians.
newtype Angle = Angle Number

-- | Convert degrees to an `Angle` in radians.
degrees :: Number -> Angle
degrees d = Angle $ tau * d / 360.0

-- | Get the `Angle` corresponding to a fraction of a circle.
tauOver :: Number -> Angle
tauOver n = Angle $ tau / n

-- | Container indexed by the four corners of a rectangle.
newtype RectCorners a = RectCorners
  { tl :: a
  , tr :: a
  , bl :: a
  , br :: a
  }

derive instance Functor RectCorners

instance Apply RectCorners where
  apply (RectCorners f) (RectCorners a) = RectCorners
    { tl: f.tl a.tl
    , tr: f.tr a.tr
    , bl: f.bl a.bl
    , br: f.br a.br
    }

instance Applicative RectCorners where
  pure a = RectCorners
    { tl: a
    , tr: a
    , bl: a
    , br: a
    }

-- | The top left is considered the first and leftmost corner.
-- | The direction "right" is considered to be clockwise,
-- | so `foldl` folds clockwise from the top left
-- | and `foldr` folds counterclockwise from the bottom left.
instance Foldable RectCorners where
  foldr f b (RectCorners c) = f c.tl $ f c.tr $ f c.br $ f c.bl b
  foldl f b (RectCorners c) = b `f` c.tl `f` c.tr `f` c.br `f` c.bl
  foldMap f (RectCorners c) = f c.tl <> f c.tr <> f c.br <> f c.bl

instance Foldable1 RectCorners where
  foldr1 f (RectCorners c) = f c.tl $ f c.tr $ f c.br c.bl
  foldl1 f (RectCorners c) = c.tl `f` c.tr `f` c.br `f` c.bl
  foldMap1 f (RectCorners c) = f c.tl <> f c.tr <> f c.br <> f c.bl

-- | Any kind of thing defined by a start and an end.
type Interval a =
  { start :: a
  , end :: a
  }

-- | The nonzero winding rule is considered the default.
data CanvasFillRule = NonzeroWindingFill | EvenOddFill

instance Show CanvasFillRule where
  show NonzeroWindingFill = "nonzero"
  show EvenOddFill = "evenodd"
