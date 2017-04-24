# k-Means 聚类

目标：将数据分成两个或者多个簇

k-Means 算法背后的思想拿到一组数据并且判定在这些数据中是否有一些天然的簇（相关对象的组）。

k-Means 算法也叫做 *无监督* 的学习算法。我们不需要提前知道数据中存在什么模式 -- 没有正式的分类 -- 但是我们想看看是否能将数据分成若干组。

例如，可以使用 k-Means 方法通过将图片的原色放到 3 个簇里来找到这个图片的 3 个主要颜色。或者可以用它来讲相关的新闻文章放到一起，而不用提前确定用哪些分类。算法会自动找出最适合的组。

k-Means 里的 “k” 是一个数字。算法假定数据中有 **k** 个中心，而这些数据就围绕着这个中心。最接近这些所谓的 **质心** 的数据就变成了分类或者组了。

k-Means 不会告诉你每个特定数据组的分类。将新闻分成组之后，它不会说组 1 是关于科学的，组 2 是关于名人的，组 3 是关于即将到来的大选的，等等等。你只知道这些相关的新闻聚在一起了，但是没必要知道是什么关系。k-Means 只是帮助找到有哪些潜在的簇。

## 算法

k-Means 算法的核心其实非常简单。

首先，选择随机的 **k** 个数据点作为初始的质心。然后，重复下面的两个步骤知道找到簇：

1. 对于每一个数据点，找到它最近的质心。将这个点分到它最近的质心。
2. 更新质心到最近的数据点（即，平均值）。移动质心的目的就是使得它的确是这个簇的中心。

上面的步骤需要重复多次，因为移动质心会改变从属于它的店。这需要反复来回知道所有的东西都稳定下来。也就是要达到 “汇聚” 的目标，即，当质心不再变化。

k-Means 需要一些参数：

- **k**：需要定位的质心的数量。如果想要分组新闻文章，这就是想要的分组数量。
- **收敛距离**：在某个更新步骤之后，如果所有质心移动的距离在这个范围内，就算完成了。
- **距离函数**：计算数据点里质心的距离，以便找到它属于哪个质心。有很多距离函数可以用，但最常用的 Euclidean 距离函数就足够了（你直到的，毕达哥拉斯嘛）。但是通常也会导致汇聚不能覆盖更大的范围。

让我们来看一个例子吧。

#### 好的簇

展示 k-Means 的第一个例子是找到三个簇。在所有的例子中，圆点就代表数据点，星星代表质心。

在第一个迭代中，随机选择三个数据点作为质心。在后续的每个迭代中，找到哪些数据点靠近这些质心，然后将质心移动到这些数据点的平均的位置。一直重复直到达到平衡并且质心不再移动。

![Good Clustering](Images/k_means_good.png)

初始质心的选择是偶然的！我们发现左下角的簇（由红色标识）比上面左边的簇要更好。

> **注意：** 这些例子用来展示 k-Means 和查找簇有些勉强。这些例子中的簇很容易就通过人眼来标识出来：我们看到左下角有一个，一个在右上角，可能中间还有一个。然而，在实际中，数据可能有很多特征，还很可能不能被可视化。在这样的情况下，k-Means 就比人眼要强多了！

#### 坏的簇

下面两个例子就展示了 k-Means 的不可预测性以及它并不是总能找到最好的簇。

![Bad Clustering 1](Images/k_means_bad1.png)

就像你在例子中看到的，开始的质心有点离的太近了，蓝色执行并没有在一个比较好的位置。通过调整收敛距离我们应该可以提高质心对数据的拟合。

![Bad Clustering 1](Images/k_means_bad2.png)

在这个例子中，蓝色的簇并不能真的从红色的簇中分离出来，这样的话就卡在这里了。

#### 改善坏簇

在 “坏” 簇的例子中，算法卡在局部优化了。它虽然找到了簇但是并没有很好的分离数据。为了提高成功的机会，可以多运行几次这个算法，每次选择不同的初始质心。然后选择结果最好的簇。

如何计算 “好” 簇呢，找到每个数据到它的簇的距离，将它们加起来。这个数字越小越好！这就意味着每个簇确实在这组数据的中心，并且所有的簇也基本上都是同样大小，空间也是差不多大。

## 代码

下面是 Swift 中算法。`points` 数组中包含了 `Vector` 对象的输入数据。输入是一个 `Vector` 对象的数组，表示的是找到的簇。

```swift
func kMeans(numCenters: Int, convergeDistance: Double, points: [Vector]) -> [Vector] {
 
  // Randomly take k objects from the input data to make the initial centroids.
  var centers = reservoirSample(points, k: numCenters)

  // This loop repeats until we've reached convergence, i.e. when the centroids
  // have moved less than convergeDistance since the last iteration.
  var centerMoveDist = 0.0
  repeat {
    // In each iteration of the loop, we move the centroids to a new position.
    // The newCenters array contains those new positions.
    let zeros = [Double](count: points[0].length, repeatedValue: 0)
    var newCenters = [Vector](count: numCenters, repeatedValue: Vector(zeros))

    // We keep track of how many data points belong to each centroid, so we
    // can calculate the average later.
    var counts = [Double](count: numCenters, repeatedValue: 0)

    // For each data point, find the centroid that it is closest to. We also 
    // add up the data points that belong to that centroid, in order to compute
    // that average.
    for p in points {
      let c = indexOfNearestCenter(p, centers: centers)
      newCenters[c] += p
      counts[c] += 1
    }
    
    // Take the average of all the data points that belong to each centroid.
    // This moves the centroid to a new position.
    for idx in 0..<numCenters {
      newCenters[idx] /= counts[idx]
    }

    // Find out how far each centroid moved since the last iteration. If it's
    // only a small distance, then we're done.
    centerMoveDist = 0.0
    for idx in 0..<numCenters {
      centerMoveDist += centers[idx].distanceTo(newCenters[idx])
    }
    
    centers = newCenters
  } while centerMoveDist > convergeDistance

  return centers
}
```

> **注意：** [KMeans.swift](KMeans.swift) 里的代码比上面列出来的更高级一些。它还会给簇加上标签并且还有一些别的花样。自己看看吧！

## 性能

k-Means 被归类为 NP 难度的问题。意思就是几乎很难找到最好的解决方案。初始质心的选择对簇的结果有很大的影响。找到一个确定的解决方法是不可能的 -- 即使是在二维空间里。

从上面的步骤来看，复杂性还不算很遭 -- 通常来说都是 **O(kndi)** 的，**k** 是质心的数量，**n** 是向量的维度 **d** 的数量，**i** 是汇聚迭代的次数。

数据的数量对 k-Means 的运行时间只有线性的影响，但是质心的覆盖范围对迭代的次数却有很大的影响。一般来说，**k** 相对向量的数量来说是影响是小的。

经常有一些数据会在两个质心的边界区域，这些质心就会在前后摆动，收敛距离要避免这种情况。

## 参考

[K-Means 聚类 维基百科](https://en.wikipedia.org/wiki/K-means_clustering)

*作者：John Gill 和 Matthijs Hollemans 翻译：Daisy*


