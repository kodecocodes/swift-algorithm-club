//
//  KMeans.swift
//
//  Created by John Gill on 2/25/16.

import Foundation

class KMeans<Label: Hashable> {
  let numCenters: Int
  let labels: Array<Label>
  private(set) var centroids: Array<Vector>

  init(labels: Array<Label>) {
    assert(labels.count > 1, "Exception: KMeans with less than 2 centers.")
    self.labels = labels
    self.numCenters = labels.count
    centroids = []
  }

  private func nearestCenterIndex(x: Vector, centers: [Vector]) -> Int {
    var nearestDist = DBL_MAX
    var minIndex = 0
    
    for (idx, center) in centers.enumerate() {
      let dist = x.distTo(center)
      if dist < nearestDist {
        minIndex = idx
        nearestDist = dist
      }
    }
    return minIndex
  }
  
  
  
  func trainCenters(points: [Vector], convergeDist: Double) {
    
    var centerMoveDist = 0.0
    let zeroVector = Vector(d: [Double](count: points[0].length, repeatedValue: 0.0))
    
    var kCenters = reservoirSample(points, k: numCenters)
    
    repeat {
      
      var classification: Array<[Vector]> = Array(count: numCenters, repeatedValue: [])
      
      for p in points {
        let classIndex = nearestCenterIndex(p, centers: kCenters)
        classification[classIndex].append(p)
      }
      
      let newCenters = classification.map { assignedPoints in
        assignedPoints.reduce(zeroVector, combine: +) / Double(assignedPoints.count)
      }
      
      centerMoveDist = 0.0
      for idx in 0..<numCenters {
        centerMoveDist += kCenters[idx].distTo(newCenters[idx])
      }
      
      kCenters = newCenters
    } while centerMoveDist > convergeDist

    centroids = kCenters
  }
  
  func fit(point: Vector) -> Label {
    assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")
    
    let centroidIndex = nearestCenterIndex(point, centers: centroids)
    return labels[centroidIndex]
  }
  
  func fit(points: [Vector]) -> [Label] {
    assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")
    
    return points.map(fit)
  }
}

// Pick k random elements from samples
func reservoirSample<T>(samples:[T], k:Int) -> [T] {
  var result = [T]()
  
  // Fill the result array with first k elements
  for i in 0..<k {
    result.append(samples[i])
  }
  // randomly replace elements from remaining pool
  for i in (k+1)..<samples.count {
    let j = random() % (i+1)
    if j < k {
      result[j] = samples[i]
    }
  }
  return result
}

