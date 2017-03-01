# Haversine Distance

Calculates the distance on a sphere between two points given in latitude and longitude using the haversine formula.

The haversine formula can be found on [Wikipedia](https://en.wikipedia.org/wiki/Haversine_formula)

The Haversine Distance is implemented as a function as a class would be kind of overkill.

`haversineDinstance(la1: Double, lo1: Double, la2: Double, lo2: Double, radius: Double = 6367444.7) -> Double`

- `la1` is the latitude of point 1 in degrees.
- `lo1` is the longitude of point 1 in degrees.
- `la2` is the latitude of point 2 in degrees.
- `lo2` is the longitude of point 2 in degrees.
- `radius` is the radius of the sphere considered in meters, which defaults to the mean radius of the earth (from [WolframAlpha](http://www.wolframalpha.com/input/?i=earth+radius)).

The function contains 3 closures in order to make the code more readable and comparable to the Haversine formula given by the Wikipedia page mentioned above.

1. `haversine` implements the haversine, a trigonometric function.
2. `ahaversine` the inverse function of the haversine.
3. `dToR` a closure converting degrees to radians.

The result of `haversineDistance` is returned in meters.

*Written for Swift Algorithm Club by Jaap Wijnen.*
