// Written by John Gill and Matthijs Hollemans
// For https://github.com/raywenderlich/swift-algorithm-club
// Modified by Nicolas Zinovieff

import Foundation

#if os(Linux)
	import Glibc
    srandom(UInt32(time(nil)))
#endif

protocol VectorProtocol {
    func distanceTo(_ o: Self) -> Double
    static func average(_ items: [Self]) -> Self
}

class KMeans<Label: Hashable, Vector : VectorProtocol > {
  let numCenters: Int
  let labels: [Label]
  private(set) var centroids = [Vector]()

  init(labels: [Label]) {
    assert(labels.count > 1, "Exception: KMeans with less than 2 centers.")
    self.labels = labels
    self.numCenters = labels.count
  }

  private func indexOfNearestCenter(_ x: Vector, centers: [Vector]) -> Int {
    var nearestDist = Double.greatestFiniteMagnitude
    var minIndex = 0

    for (idx, center) in centers.enumerated() {
      let dist = x.distanceTo(center)
      if dist < nearestDist {
        minIndex = idx
        nearestDist = dist
      }
    }
    return minIndex
  }

  func trainCenters(_ points: [Vector], convergeDistance: Double) {
    // Randomly take k objects from the input data to make the initial centroids.
    var centers = reservoirSample(points, k: numCenters)

    var centerMoveDist = 0.0
    repeat {
      // This array keeps track of which data points belong to which centroids.
      var classification: [[Vector]] = .init(repeating: [], count: numCenters)

      // For each data point, find the centroid that it is closest to.
      for p in points {
        let classIndex = indexOfNearestCenter(p, centers: centers)
        classification[classIndex].append(p)
      }

      // Take the average of all the data points that belong to each centroid.
      // This moves the centroid to a new position.
      let newCenters = classification.map { assignedPoints -> Vector in
        return Vector.average(assignedPoints)
      }

      // Find out how far each centroid moved since the last iteration. If it's
      // only a small distance, then we're done.
      centerMoveDist = 0.0
      for idx in 0..<numCenters {
        centerMoveDist += centers[idx].distanceTo(newCenters[idx])
      }

      centers = newCenters
    } while centerMoveDist > convergeDistance

    centroids = centers
  }

  func fit(_ point: Vector) -> Label {
    assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")

    let centroidIndex = indexOfNearestCenter(point, centers: centroids)
    return labels[centroidIndex]
  }

  func fit(_ points: [Vector]) -> [Label] {
    assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")

    return points.map(fit)
  }
}

// Pick k random elements from samples
func reservoirSample<T>(_ samples: [T], k: Int) -> [T] {
  var result = [T]()

  // Fill the result array with first k elements
  for i in 0..<k {
    result.append(samples[i])
  }

  // Randomly replace elements from remaining pool
  for i in k..<samples.count {
  	#if os(Linux)
    let j = Int(random() % (i + 1))
    #else
    let j = Int(arc4random_uniform(UInt32(i + 1)))
    #endif
    if j < k {
      result[j] = samples[i]
    }
  }
  return result
}

// EXAMPLE : points (as in the README)
struct Point : VectorProtocol {
	let x : Double
	let y : Double
	
	func distanceTo(_ o: Point) -> Double {
		let aSquared : Double = (o.y-self.y)*(o.y-self.y)
		let bSquared : Double = (o.x-self.x)*(o.x-self.x)
		return sqrt(aSquared+bSquared) // Pythagoras 🥰
	}
	
	static func average(_ items: [Point]) -> Point { // barycenter
		if items.count == 0 { // division by zero is bad news
			return Point(x:0, y:0)
		}
		
		var sumX = 0.0
		var sumY = 0.0
		
		for i in items {
			sumX += i.x
			sumY += i.y
		}
		
		let doubleCount = Double(items.count)
		sumX /= doubleCount
		sumY /= doubleCount
		
		return Point(x: sumX, y: sumY)
	}
}
