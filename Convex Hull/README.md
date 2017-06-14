# Convex Hull

There are multiple Convex Hull algorithms. This particular implementation uses the Quickhull algorithm.

Given a group of points on a plane. The Convex Hull algorithm calculates the shape (made up from the points itself) containing all these points. It can also be used on a collection of points of different dimensions. This implementation however covers points on a plane. It essentially calculates the lines between points which together contain all points.

## Quickhull

The quickhull algorithm works as follows:
The algorithm takes an input of a collection of points. These points should be ordered on their x-coordinate value. We pick the two points A and B with the smallest(A) and the largest(B) x-coordinate. These of course have to be part of the hull. Imagine a line from point A to point B. All points to the right of this line are grouped in an array S1. Imagine now a line from point B to point A. (this is of course the same line as before just with opposite direction) Again all points to the right of this line are grouped in an array, S2 this time.
We now define the following recursive function:

`findHull(points: [CGPoint], p1: CGPoint, p2: CGPoint)`

```
findHull(S1, A, B)
findHull(S2, B, A)
```

What this function does is the following:
1. If `points` is empty we return as there are no points to the right of our line to add to our hull.
2. Draw a line from `p1` to `p2`.
3. Find the point in `points` that is furthest away from this line. (`maxPoint`)
4. Add `maxPoint` to the hull right after `p1`.
5. Draw a line (`line1`) from `p1` to `maxPoint`.
6. Draw a line (`line2`) from `maxPoint` to `p2`. (These lines now form a triangle)
7. All points within this triangle are of course not part of the hull and thus can be ignored. We check which points in `points` are to the right of `line1` these are grouped in an array `s1`.
8. All points that are to the right of `line2` are grouped in an array `s2`. Note that there are no points that are both to the right of `line1` and `line2` as then `maxPoint` wouldn't be the point furthest away from our initial line between `p1` and `p2`.
9. We call `findHull(_, _, _)` again on our new groups of points to find more hull points.
```
findHull(s1, p1, maxPoint)
findHull(s2, maxPoint, p2)
```

This eventually leaves us with an array of points describing the convex hull.

## See also

[Convex Hull on Wikipedia](https://en.wikipedia.org/wiki/Convex_hull_algorithms)

*Written for the Swift Algorithm Club by Jaap Wijnen.*
