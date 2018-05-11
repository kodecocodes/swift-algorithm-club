# ClosestPair

Closest Pair is an algorithm that finds the closest pair of a given array of points By utilizing the Divide and Conquer methodology of solving problems so that it reaches the correct solution with O(nlogn) complexity.

![Given points and we're required to find the two red ones](Images/1200px-Closest_pair_of_points.png)

As we see in the above image there are an array of points and we need to find the closest two, But how do we do that without having to compare each two points which results in a whopping O(n^2) complexity?

Here is the main algorithm (Steps) we'll follow.

- Sort the array according to their position on the X-axis so that they are sorted in the array as they are naturally in math.

```swift
var innerPoints = mergeSort(points, sortAccording : true)
```

- Divide the points into two arrays Left, Right and keep dividing until you reach to only having 3 points in your array.

- The base case is you have less than 3 points compare those against each other (Brute force) then return the minimum distance you found and the two points.

- Now we get the first observation in the below image, There could be 2 points both very close to each other and indeed those two are the closest pair but since our algorithm so far divides from the middle
 
```swift
let line:Double = (p[mid].x + p[mid+1].x)/2
```

and just recursively calls itself until it reaches the base case we don't detect those points.

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
