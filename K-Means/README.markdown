# k-Means Clustering

Goal: Partition data into **k** clusters based on nearest means.

The idea behind k-Means is to take data that has no formal classification to it and determine if there are any natural clusters (groups of related objects) within the data.

k-Means assumes that there are **k-centers** within the data. The data that is closest to these *centroids* become classified or grouped together. k-Means doesn't tell you what the classifier is for that particular data group, but it assists in trying to find what clusters potentially exist.

## The algorithm

The k-Means algorithm is really quite simple at its core:

1. Choose **k** random points to be the initial centers
2. Repeat the following two steps until the *centroids* reach convergence:
	1. Assign each point to its nearest *centroid*
	2. Update the *centroid* to the mean of its nearest points

Convergence is said to be reached when all of the *centroids* have not changed.

This brings about a few of the parameters that are required for k-Means:

- **k**: This is the number of *centroids* to attempt to locate.
- **convergence distance**: The minimum distance that the centers are allowed to move after a particular update step.
- **distance function**: There are a number of distance functions that can be used, but mostly commonly the Euclidean distance function is adequate. But often that can lead to convergence not being reached in higher dimensionally.

This is what the algorithm would look like in Swift:

```swift
func kMeans(numCenters: Int, convergeDist: Double, points: [Vector]) -> [Vector] {
  var centerMoveDist = 0.0
  let zeros = [Double](count: points[0].length, repeatedValue: 0.0)
  
  var kCenters = reservoirSample(points, k: numCenters)
  
  repeat {
    var cnts = [Double](count: numCenters, repeatedValue: 0.0)
    var newCenters = [Vector](count:numCenters, repeatedValue: Vector(d:zeros))

    for p in points {
      let c = nearestCenter(p, centers: kCenters)
      cnts[c] += 1
      newCenters[c] += p
    }
    
    for idx in 0..<numCenters {
      newCenters[idx] /= cnts[idx]
    }
    
    centerMoveDist = 0.0
    for idx in 0..<numCenters {
      centerMoveDist += euclidean(kCenters[idx], newCenters[idx])
    }
    
    kCenters = newCenters
  } while centerMoveDist > convergeDist

  return kCenters
}
```

## Example

These examples are contrived to show the exact nature of k-Means and finding clusters. These clusters are very easily identified by human eyes: we see there is one in the lower left corner, one in the upper right corner, and maybe one in the middle.

In all these examples the squares represent the data points and the stars represent the *centroids*.

##### Good clusters

This first example shows k-Means finding all three clusters:

![Good Clustering](Images/k_means_good.png)

The selection of initial centroids found the lower left cluster (indicated by red) and did pretty good on the center and upper left clusters.

#### Bad Clustering

The next two examples highlight the unpredictability of k-Means and how it not always finds the best clustering.

![Bad Clustering 1](Images/k_means_bad1.png)

As you can see in this one, the initial *centroids* were all a little too close and the 'blue' didn't quite get to a good place. By adjusting the convergence distance we should be able to get it better.

![Bad Clustering 1](Images/k_means_bad2.png)

In this example, the blue cluster never really could separate from the red cluster and as such sort of got stuck down there.

## Performance

The first thing to recognize is that k-Means is classified as an NP-Hard type of problem. The selection of the initial *centroids* has a big effect on how the resulting clusters may end up. This means that trying to find an exact solution is not likely -- even in 2 dimensional space.

As seen from the steps above the complexity really isn't that bad -- it is often considered to be on the order of **O(kndi)**, where **k** is the number of *centroids*, **n** is the number of **d**-dimensional vectors, and **i** is the number of iterations for convergence.

The amount of data has a big linear effect on the running time of k-Means, but tuning how far you want the *centroids* to converge can have a big impact how many iterations will be done. As a general rule, **k** should be relatively small compared to the number of vectors.

Often times as more data is added certain points may lie in the boundary between two *centroids* and as such those centroids would continue to bounce back and forth and the **convergence** distance would need to be tuned to prevent that.

## See Also

[K-Means Clustering on Wikipedia](https://en.wikipedia.org/wiki/K-means_clustering)

*Written by John Gill*
