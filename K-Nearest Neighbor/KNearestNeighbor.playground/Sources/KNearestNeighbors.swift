//
//  kNearestNeighbors.swift
//
//
//  Created by Егор on 3/20/19.
//

import Foundation

public class KNearestNeighbors<Label, Feature: Numeric> {
    private let neighborNumber: Int
    private let data: [[Feature]]
    private let labels: [Label]

    public init(_ data: [[Feature]], _ labels: [Label], neighborNumber: Int = 3) {
        self.data = data
        self.labels = labels
        self.neighborNumber = neighborNumber

        guard data.count == labels.count else {
            fatalError("Length of Data not equal to length of Labels \(data.capacity) != \(labels.count)")
        }

        guard neighborNumber <= data.count else {
            fatalError("Number of neighbors is less than total number of points")
        }
    }

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

    // Helper function to calculate euclidian distance
    private func euclideanDistance(_ xTrain: [Feature], _ xTest: [Feature]) -> Double {
        guard xTrain.count == xTest.count else {
            fatalError("Features' lengths are not equal")
        }
        guard let xTrain = xTrain as? [Double], let xTest = xTest as? [Double] else {
            fatalError("Invalid input")
        }

        // Calculate euclidean distances sqrt((x1 - x0)^2 - (y1 - y0)^2)
        var euclideanDistance = 0.0
        for (index, _) in xTrain.enumerated() {
            euclideanDistance += pow(xTrain[index] - xTest[index].magnitude, 2)
        }

        return sqrt(euclideanDistance)
    }

}
