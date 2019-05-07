# Points Lines (Planes)
This implements data structures for points lines and planes(not yet) in (for now) 2D space and a few functions to play around with them. This was originally written to improve on the Convex Hull algorithm but I thought it might be a nice addition in itself. Im planning to add 3D implementations as well.

# implementation
Two `struct`s are implemented the `Point2D` and `Line2D`.

```
struct Point2D: {
  var x: Double
  var y: double
}
```

```
struct Line2D {
  var slope: Slope
  var offset: Double
  var direction: Direction
}
```
Here `Slope` is an enum to account for vertical lines.
slope is infinite for vertical lines, offset is the x coordinate where the line crosses the line `y=0`.
slope is finite for any other line and contains a double with the actual value of the slope.
```
enum Slope {
  case finite(slope: Double)
  case infinite(offset: Double)
}
```
`Line2D` also contains a `Direction` enum. This is introduced in order to make lines directional in order to be able to determine what is left and right of a certain line. It is `.increasing` if the line points in positive y direction and `.decreasing` if it points in the negative y direction.

`Line2D`'s offset is the the y-coordinate where the line crosses the vertical `x=0` line.

*Written for the Swift Algorithm Club by Jaap Wijnen.*
