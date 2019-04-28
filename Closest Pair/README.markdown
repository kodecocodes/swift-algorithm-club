# ClosestPair

Closest Pair is an algorithm that finds the closest pair of a given array of points by utilizing the "Divide and Conquer" methodology of solving problems. The implementation that you'll see here achieves O(nlogn) time complexity.

![Given points and we're required to find the two red ones](Images/1200px-Closest_pair_of_points.png)

The image above shows a number of points in a two dimensional space. The closest pair algorithm is implemented by the following steps:

## Sorting

You'll first sort the array by using `mergeSort`, one of the most efficient general purpose sorting algorithms. Mergesort has a time complexity of `O(nlogn)`, which is as fast as you can achieve for general comparison based sorting algorithms:

```swift
var innerPoints = mergeSort(points, sortAccording : true)
```

## Divide and Conquer

The next step is to divide the sorted array into sub arrays. You'll stop the division once each sub-division have fewer than three elements. Once you've reached this point, you'll choose two of the three points that represent the minimum distance of the sub-array.

As the recursive function unravels, the minimum distances will be compared and the ultimate mininum distance will be returned.

### Predicament

The following image 

![ Points lying near the division line](Images/Case.png)

- To solve this we start by sorting the array on the Y-axis to get the points in their natural order and then we start getting the difference between the X position of the point and the line we drew to divide and if it is less than the min we got so far from the recursion we add it to the strip 

```swift
var strip = [Point]()   
var i=0, j = 0
while i<n
{
	if abs(p[i].x - line) < min
	{
		strip.append(p[i])
		j+=1
	}
	i+=1
}
```

- After you insert the points that could possibly give you a better min distance we get to another observation in the image below.

![The strip with 4 points shown](Images/Strip.png)

- Searching the strip is a brute force loop (But doesn't that just destroy everything we did? You ask) but it has an advantage it could never iterate on more than 8 points (worst case).

- The reason is that the strip is constructed as a rectangle with sides of length = min that we got from the recursion and we ignore any points that have a Y difference bigger than min distance so to be able to place them ALL inside the rectangle with these conditions they'll have to be in the shape above with each one of them EXACTLY min distance away from the other which gives us 4 possible points for each one and 8 in total.

```swift
while i<j
    {
        x = i+1
        while x < j
        {
            if (abs(strip[x].y - strip[i].y)) > min { break }
            if dist(strip[i], strip[x]) < temp
            {
                temp = dist(strip[i], strip[x])
                tempFirst = strip[i]
                tempSecond = strip[x]
            }
            x+=1
        }
        i+=1
    }
```

- Of course not every time you end up with the same shape but this is the worst case and it's rare to happen so in reality you end up with far less points valid for comparison and this is why the algorithm gets performance in addition to the sorting tricks we did.

- Compare the points in the strip and if you find a smaller distance replace the current one with it.


So this is the rundown of how the algorithm works and you could see the fun little math tricks used to optimize this and we end up with O(nlogn) complexity mainly because of the sorting.


## See also

See the playground to play around with the implementation of the algorithm

[Wikipedia](https://en.wikipedia.org/wiki/Closest_pair_of_points_problem)

*Written for Swift Algorithm Club by [Ahmed Nader](https://github.com/ahmednader42)*
