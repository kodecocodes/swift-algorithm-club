# k-Nearest Neighbor Classifier

Goal: Assign label to the feature based on the labels of the nearest data points.

k-Nearest Neighbor Classifier is a supervised machine learning algorithm which assigns labels based on the feature similarity. A data instance is therefore classified by the majority vote between **k-Nearest neighbors**.

KNN is **lazy** machine learning algorithm which means that it has little to no training phase and does not use any training data to deduce certain generalizations about the whole data set. 
## The algorithm

The k-Nearest neighbor classifier is one of the simplest machine learning algorithms there is.

1. We have to decide on the parameter **k** which decides how many nearest neighbors to take into account. 
2. For every new data point we calculate the distance (usually, euclidean) from it to each data point in the training set.
3. Then we take out the **k** closest neighbors to the test point. 
4. Finally, the label of the test point is decided by the majority voting between the nearest neighbors.

For **k = 1** the prediction is based only upon the single closest neighbor.

For **k > 1** prediction is determined by a majority vote.

In a two-class (binary) problem it is preferable to choose **k** odd to prevent ties.

![alt text](./Images/knn.png)

## The code

k-Nearest Neighbor is quite easy to implement. Below is one of the possible implementations. *Feature* is numeric data type for the data points. *Label* is also a numeric data type but for labels (or classes).

```swift
    public func predict(_ xTest: [[Feature]]) -> [Label]? {
        return xTest.map {
            nearestNeighbors(for: $0)
        }.map {
            label(from: $0)
        }
    }

    // Get k-closest neighbors for instance
    private func nearestNeighbors(for instance: [Feature]) -> [Int] {
        var distances = [(index: Int, value: Double)]()
        for (index, feature) in self.data.enumerated() {
            distances.append((index: index, value: euclideanDistance(feature, instance)))
        }
        // Sort in descending order
        distances.sort {
            $0.value < $1.value
        }
        // Leave only first n closest neighbors
        distances.removeLast(distances.count - self.neighborNumber)
        // Return the indeces of nearest neighbors
        return distances.map {
            $0.index
        }
    }

    // Get the predicted label from the indeces of k-closest neighbors
    private func label(from indices: [Int]) -> Label {
        // Dictionary to store counts of the individual labels like [label: labelCount]
        var labelCount = [Int: Int]()

        var mostCommonElementIndex: Int = 0
        var mostCommonElementCount: Int = 0
        for index in indices {
            if let count = labelCount[index] {
                labelCount[index] = count + 1
            } else {
                labelCount[index] = 1
            }
            if labelCount[index]! > mostCommonElementCount {
                mostCommonElementCount = labelCount[index]!
                mostCommonElementIndex = index
            }
        }

        return self.labels[mostCommonElementIndex]
    }
```


## See Also

[K-Nearest Neighbors on Wikipedia](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm)

*Written by Yegor Chsherbatykh*

