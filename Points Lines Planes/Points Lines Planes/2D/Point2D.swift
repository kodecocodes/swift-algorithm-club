//
//  Point2D.swift
//  Points Lines Planes
//
//  Created by Jaap Wijnen on 24-10-17.
//

struct Point2D: Equatable {
    var x: Double
    var y: Double
    
    // returns true if point is on or right of line
    func isRight(of line: Line2D) -> Bool {
        switch line.slope {
        case .finite:
            let y = line.y(at: self.x)
            switch line.direction {
            case .increasing:
                return y >= self.y
            case .decreasing:
                return y <= self.y
            }
        case .infinite(let offset):
            switch line.direction {
            case .increasing:
                return self.x >= offset
            case .decreasing:
                return self.x <= offset
            }
        }
    }
    
    func isLeft(of line: Line2D) -> Bool {
        return !self.isRight(of: line)
    }
}
