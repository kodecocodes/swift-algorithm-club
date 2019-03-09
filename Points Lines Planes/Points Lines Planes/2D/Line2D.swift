//
//  Line2D.swift
//  Points Lines Planes
//
//  Created by Jaap Wijnen on 24-10-17.
//

struct Line2D: Equatable {
    
    var slope: Slope
    var offset: Double
    var direction: Direction
    
    enum Slope: Equatable {
        case finite(slope: Double)
        case infinite(offset: Double)
    }
    
    enum Direction: Equatable {
        case increasing
        case decreasing
    }
    
    init(from p1: Point2D, to p2: Point2D) {
        if p1 == p2 { fatalError("Points can not be equal when creating a line between them") }
        if p1.x == p2.x {
            self.slope = .infinite(offset: p1.x)
            self.offset = 0
            self.direction = p1.y < p2.y ? .increasing : .decreasing
            
            return
        }
        
        let slope = (p1.y - p2.y)/(p1.x - p2.x)
        self.slope = .finite(slope: slope)
        offset = (p1.y + p2.y - slope * (p1.x + p2.x))/2
        if slope >= 0 {
            // so a horizontal line going left to right is called increasing
            self.direction = p1.x < p2.x ? .increasing : .decreasing
        } else {
            self.direction = p1.x < p2.x ? .decreasing : .increasing
        }
    }
    
    fileprivate init(slope: Slope, offset: Double, direction: Direction) {
        self.slope = slope
        self.offset = offset
        self.direction = direction
    }
    
    // returns y coordinate on line for given x
    func y(at x: Double) -> Double {
        switch self.slope {
        case .finite(let slope):
            return slope * x + self.offset
        case .infinite:
            fatalError("y can be anywhere on vertical line")
        }
    }
    
    // returns x coordinate on line for given y
    func x(at y: Double) -> Double {
        switch self.slope {
        case .finite(let slope):
            if slope == 0 {
                fatalError("x can be anywhere on horizontal line")
            }
            return (y - self.offset)/slope
        case .infinite(let offset):
            return offset
        }
    }
    
    // finds intersection point between two lines. returns nil when lines don't intersect or lie on top of each other.
    func intersect(with line: Line2D) -> Point2D? {
        if self == line { return nil }
        switch (self.slope, line.slope) {
        case (.infinite, .infinite):
            // lines are either parallel or on top of each other.
            return nil
        case (.finite(let slope1), .finite(let slope2)):
            if slope1 == slope2 { return nil } // lines are parallel
            // lines are not parallel calculate intersection point
            let x = (line.offset - self.offset)/(slope1 - slope2)
            let y = (slope1 + slope2) * x + self.offset + line.offset
            return Point2D(x: x, y: y)
        case (.infinite(let offset), .finite):
            // one line is vertical so we only check what y value the other line has at that point
            let x = offset
            let y = line.y(at: x)
            return Point2D(x: x, y: y)
        case (.finite, .infinite(let offset)):
            // one line is vertical so we only check what y value the other line has at that point
            // lines are switched with respect to case above this one
            let x = offset
            let y = self.y(at: x)
            return Point2D(x: x, y: y)
        }
    }
    
    // returns a line perpendicular to self at the given y coordinate
    // direction of perpendicular lines always changes clockwise
    func perpendicularLineAt(y: Double) -> Line2D {
        return perpendicularLineAt(p: Point2D(x: self.x(at: y), y: y))
    }
    
    // returns a line perpendicular to self at the given x coordinate
    // direction of perpendicular lines always changes clockwise
    func perpendicularLineAt(x: Double) -> Line2D {
        return perpendicularLineAt(p: Point2D(x: x, y: self.y(at: x)))
    }
    
    private func perpendicularLineAt(p: Point2D) -> Line2D {
        switch self.slope {
        case .finite(let slope):
            if slope == 0 {
                // line is horizontal so new line will be vertical
                let dir: Direction = self.direction == .increasing ? .decreasing : .increasing
                return Line2D(slope: .infinite(offset: p.x), offset: 0, direction: dir)
            }
            
            // line is neither horizontal nor vertical
            // we make a new line through the point p with new slope -1/slope
            let offset = (slope + 1/slope)*p.x + self.offset
            
            // determine direction of new line based on direction of the old line and its slope
            let dir: Direction
            switch self.direction {
            case .increasing:
                dir = slope > 0 ? .decreasing : .increasing
            case .decreasing:
                dir = slope > 0 ? .increasing : .decreasing
            }
            return Line2D(slope: .finite(slope: -1/slope), offset: offset, direction: dir)
        case .infinite:
            // line is vertical so new line will be horizontal
            let dir: Direction = self.direction == .increasing ? .increasing : .decreasing
            return Line2D(slope: .finite(slope: 0), offset: p.y, direction: dir)
        }
    }
}
