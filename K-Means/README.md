# K-Means

Goal:  Partition data into k clusters based on nearest means

The idea behind K-Means is to try and take data that has no formal classification to it and determine if there are any natural clusters within the data.

K-Means assumes that there are **k-centers** within the data. The data that is then closest to these *centroids* become classified or grouped together. K-Means doesn't tell you what the classifier is for that particular data group, but it assists in trying to find what clusters potentially exist.

## Algorithm
The k-means algorithm is really quite simple at it's core:
1. Choose k random points to be the initial centers
2. Repeat the following two steps until the *centroid* reach convergence
    1. Assign each point to it's nearest *centroid*
    2. Update the *centroid* to the mean of it's nearest points

Convergence is said to be reached when all of the *centroids* have not changed.

This brings about a few of the parameters that are required for k-means:
- **k** -  This is the number of *centroids* to attempt to locate
- **convergence distance** - This is minimum distance that the centers are allowed to moved after a particular update step.
- **distance function** - There are a number of distance functions that can be used, but mostly commonly the euclidean distance function is adequate. But often can lead to convergence not being reached in higher dimensionally.

This is what the algorithm would look like in swift
```swift
func kMeans(numCenters: Int, convergeDist: Double, points: [VectorND]) -> [VectorND] {
    var centerMoveDist = 0.0
    let zeros = [Double](count: points[0].getLength(), repeatedValue: 0.0)

    var kCenters = reservoirSample(points, k: numCenters)

    repeat {
        var cnts = [Double](count: numCenters, repeatedValue: 0.0)
        var newCenters = [VectorND](count:numCenters, repeatedValue: VectorND(d:zeros))
        for p in points {
            let c = nearestCenter(p, Centers: kCenters)
            cnts[c]++
            newCenters[c] += p
        }
        for idx in 0..<numCenters {
            newCenters[idx] /= cnts[idx]
        }
        centerMoveDist = 0.0
        for idx in 0..<numCenters {
            centerMoveDist += euclidean(kCenters[idx], v2: newCenters[idx])
        }
        kCenters = newCenters
    } while(centerMoveDist > convergeDist)
    return kCenters
}
```

## Example
These examples are contrived to show the exact nature of K-Means and finding clusters. These clusters are very easily identified by human eyes, we see there is one in the lower left corner, one in the upper right corner and maybe one in the middle.

In all these examples the stars represent the *centroids* and the squares are the points.

##### Good clusters
This first example shows K-Means finding all three clusters:
![Good Clustering](Images/k_means_good.png)

The selection of initial centroids found that lower left (indicated by red) and did pretty good on the center and upper left clusters.

#### Bad Clustering
The next two examples highlight the unpredictability of k-Means and how not always does it find the best clustering.
![Bad Clustering 1](Images/k_means_bad1.png)
As you can see in this one the initial *centroids* were all a little two close and the 'blue' didn't quite get to a good place. By adjusting the convergence distance should be able to get it better.

![Bad Clustering 1](Images/k_means_bad2.png)
This one the blue cluster never really could separate from the red cluster and as such sort of got stuck down there.

## Performance
The first thing to recognize is that k-Means is classified as an NP-Hard type of problem. The selection of the initial *centroids* has a big effect on how the resulting clusters may end up. This means that trying to find an exact solution is not likely - even in 2 dimensional space.

As seem from the steps above the complexity really isn't that bad - it is often considered to be on the order of O(kndi), where **k** is the number of *centroids*, **n** is the number of **d** dimensional vectors and **i** is the number of iterations for convergence.

The amount of data has a big linear effect on the running time of k-means, but tuning how far you want the *centroids* to converge can have a big impact how many iterations will be done - **k** should be relatively small compared to the number of vectors.

Often times as more data is added certain points may lie in the boundary between two *centroids* and as such those centroids would continue to bounce back and forth and the **convergence** distance would need to be tuned to prevent that.

## See Also
See also [Wikipedia](https://en.wikipedia.org/wiki/K-means_clustering)

*Written by John Gill*
