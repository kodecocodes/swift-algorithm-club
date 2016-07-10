# Set Cover (Unweighted)

If you have a group of sets, this algorithm finds a subset of those sets within that group whose union will cover an initial set that you're trying to match. The initial set is also known as the universe.

For example, suppose you have a universe of `{1, 5, 7}` and you want to find the sets which cover the universe within the following group of sets:

> {8, 4, 2}
> {3, 1}
> {7, 6, 5, 4}
> {2}
> {1, 2, 3}

You can see that the sets `{3, 1} {7, 6, 5, 4}` when unioned together will cover the universe of `{1, 5, 7}`. Yes, there may be additional elements in the sets returned by the algorithm, but every element in the universe is represented in the cover itself.

There may be cases where no cover exists. For example, if your universe is `{7, 9}`, there is no combination of sets within the group above that will yield a cover.

## The algorithm

The Greedy Set Cover algorithm (unweighted) is provided here. It's known as greedy because it uses the largest intersecting set from the group of sets first before examining other sets in the group. This is part of the reason why the cover may have additional elements which are not part of the universe.

The function (named `cover`) is provided as an extension of the Swift type `Set`. The function takes a single parameter, which is an array of sets. This array represents the group, and the set itself represents the universe.

One of the first things done in `cover` is to make a copy of the universe in `remainingSet`. Then, the algorithm enters a `while` loop in which a call to `largestIntersectingSet` is made. The value returned from `largestIntersectingSet` is the set which has the most elements in common with the remaining universe identified by `remainingSet`. If all sets have nothing in common, `largestIntersectingSet` returns `nil`.

If the result from `largestIntersectingSet` is not nil, that result is subtracted from `remainingSet` (reducing its size), and the loop continues until `remainingSet` has zero length (meaning a cover has been found) or until `largestIntersectingSet` returns `nil`.

If there is no cover within the group of sets, `cover` returns `nil`.

## See also

[Set cover problem on Wikipedia](https://en.wikipedia.org/wiki/Set_cover_problem)

*Written for Swift Algorithm Club by [Michael C. Rael](https://github.com/mrael2)*