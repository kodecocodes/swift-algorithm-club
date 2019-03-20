//
//  kNearestNeighbors.swift
//
//
//  Created by Егор on 3/20/19.
//

import Foundation

class kNearestNeighbors<Label: Hashable> {
    private let neighborNumber: Int
    private let data: [[Double]]
    private let labels: [Label]

    init(data: [[Double]], labels: [Label], neighborNumber: Int) {
        self.data = data
        self.labels = labels
        self.neighborNumber = neighborNumber
    }
}
