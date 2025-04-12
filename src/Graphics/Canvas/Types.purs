module Graphics.Canvas.Types
  ( module Reexports
  , CanvasRenderingContext2D
  , Point
  , Dimensions
  , Rectangle
  , Rect
  , rectangle
  , topLeft
  , topRight
  , bottomLeft
  , bottomRight
  , area
  ) where

import Prelude

import Web.HTML.HTMLCanvasElement (HTMLCanvasElement) as Reexports

foreign import data CanvasRenderingContext2D :: Type

-- | A point on the canvas.
type Point a =
  { x :: a
  , y :: a
  }

-- | The dimensions of a rectangular area, such as the canvas itself.
type Dimensions a =
  { w :: a
  , h :: a
  }

-- | A rectangle on the canvas, represented as its top left corner and its dimensions.
-- | Defined as a flat record for convenience; this is guaranteed to be stable for FFI use.
-- | Dimensions are assumed to be positive.
type Rectangle a =
  { x :: a
  , y :: a
  , w :: a
  , h :: a
  }

-- | Alias for the most common `Rectangle` in the API.
type Rect = Rectangle Number

-- | Compose a `Point` and `Dimensions` into a `Rectangle`.
rectangle :: forall a. Point a -> Dimensions a -> Rectangle a
rectangle {x, y} {h, w} = {x, y, h, w}

-- | Get the top left corner of a `Rectangle`.
topLeft :: forall a. Rectangle a -> Point a
topLeft {x, y} = {x, y}

-- | Get the top right corner of a `Rectangle`.
topRight :: forall a. Semiring a => Rectangle a -> Point a
topRight {x, y, w} = {x: x + w, y}

-- | Get the bottom left corner of a `Rectangle`.
bottomLeft :: forall a. Semiring a => Rectangle a -> Point a
bottomLeft {x, y, h} = {x, y: y + h}

-- | Get the bottom right corner of a `Rectangle`.
bottomRight :: forall a. Semiring a => Rectangle a -> Point a
bottomRight {x, y, w, h} = {x: x + w, y: y + h}

-- | Get the area of a `Rectangle` or `Dimensions`.
area :: forall a r. Semiring a => { w :: a, h :: a | r} -> a
area {w, h} = w * h
