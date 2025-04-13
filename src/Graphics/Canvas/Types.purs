module Graphics.Canvas.Types
  ( module Reexports
  , CanvasRenderingContext2D
  , Point
  , Dimensions
  , Rect
  , rectangle
  , topLeft
  , topRight
  , bottomLeft
  , bottomRight
  , area
  , ControlPoint
  ) where

import Prelude

import Web.HTML.HTMLCanvasElement (HTMLCanvasElement) as Reexports

foreign import data CanvasRenderingContext2D :: Type

foreign import data Path2D :: Type

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
rectangle :: Point Number -> Dimensions Number -> Rect Number
rectangle {x, y} {h, w} = {x, y, h, w}

-- | Get the top left corner of a `Rect`.
topLeft :: Rect Number -> Point Number
topLeft {x, y} = {x, y}

-- | Get the top right corner of a `Rect`.
topRight :: Rect Number -> Point Number
topRight {x, y, w} = {x: x + w, y}

-- | Get the bottom left corner of a `Rect`.
bottomLeft :: Rect Number -> Point Number
bottomLeft {x, y, h} = {x, y: y + h}

-- | Get the bottom right corner of a `Rect`.
bottomRight :: Rect Number -> Point Number
bottomRight {x, y, w, h} = {x: x + w, y: y + h}

-- | Get the area of a `Rect` or `Dimensions`.
area :: forall r. { w :: Number, h :: Number | r} -> Number
area {w, h} = w * h

-- | Control points for Bézier curves and other such shapes,
-- | as a newtype to make types more self-documenting in lieu of spec records.
newtype ControlPoint = ControlPoint Point
