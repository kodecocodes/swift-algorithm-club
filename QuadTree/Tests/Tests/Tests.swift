//
//  Tests.swift
//  Tests
//
//  Created by Timur Galimov on 12/02/2017.
//
//

import XCTest

extension Point: Equatable {

}

public func == (lhs: Point, rhs: Point) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

class Tests: XCTestCase {

  func testRectContains() {
    let rect = Rect(origin: Point(0, 0), size: Size(xLength: 3, yLength: 3))

    XCTAssertTrue(rect.containts(point: Point(1, 1)))
    XCTAssertTrue(rect.containts(point: Point(0, 0)))
    XCTAssertTrue(rect.containts(point: Point(0, 3)))
    XCTAssertTrue(rect.containts(point: Point(3, 3)))

    XCTAssertFalse(rect.containts(point: Point(-1, 1)))
    XCTAssertFalse(rect.containts(point: Point(-0.1, 0.1)))
    XCTAssertFalse(rect.containts(point: Point(0, 3.1)))
    XCTAssertFalse(rect.containts(point: Point(-4, 1)))
  }

  func testIntersects() {
    let rect = Rect(origin: Point(0, 0), size: Size(xLength: 5, yLength: 5))
    let rect2 = Rect(origin: Point(1, 1), size: Size(xLength: 1, yLength: 1))
    XCTAssertTrue(rect.intersects(rect: rect2))

    let rect3 = Rect(origin: Point(1, 0), size: Size(xLength: 1, yLength: 10))
    let rect4 = Rect(origin: Point(0, 1), size: Size(xLength: 10, yLength: 1))
    XCTAssertTrue(rect3.intersects(rect: rect4))

    let rect5 = Rect(origin: Point(0, 0), size: Size(xLength: 4, yLength: 4))
    let rect6 = Rect(origin: Point(2, 2), size: Size(xLength: 4, yLength: 4))
    XCTAssertTrue(rect5.intersects(rect: rect6))

    let rect7 = Rect(origin: Point(0, 0), size: Size(xLength: 4, yLength: 4))
    let rect8 = Rect(origin: Point(4, 4), size: Size(xLength: 1, yLength: 1))
    XCTAssertTrue(rect7.intersects(rect: rect8))

    let rect9 = Rect(origin: Point(-1, -1), size: Size(xLength: 0.5, yLength: 0.5))
    let rect10 = Rect(origin: Point(0, 0), size: Size(xLength: 1, yLength: 1))
    XCTAssertFalse(rect9.intersects(rect: rect10))

    let rect11 = Rect(origin: Point(0, 0), size: Size(xLength: 2, yLength: 1))
    let rect12 = Rect(origin: Point(3, 0), size: Size(xLength: 1, yLength: 1))
    XCTAssertFalse(rect11.intersects(rect: rect12))
  }

  func testQuadTree() {
    let rect = Rect(origin: Point(0, 0), size: Size(xLength: 5, yLength: 5))
    let qt = QuadTree(rect: rect)

    XCTAssertTrue(qt.points(inRect: rect) == [Point]())

    XCTAssertFalse(qt.add(point: Point(-0.1, 0.1)))

    XCTAssertTrue(qt.points(inRect: rect) == [Point]())

    XCTAssertTrue(qt.add(point: Point(1, 1)))
    XCTAssertTrue(qt.add(point: Point(3, 3)))
    XCTAssertTrue(qt.add(point: Point(4, 4)))
    XCTAssertTrue(qt.add(point: Point(0.5, 0.5)))

    XCTAssertFalse(qt.add(point: Point(5.5, 0)))
    XCTAssertFalse(qt.add(point: Point(5.5, 1)))
    XCTAssertFalse(qt.add(point: Point(5.5, 2)))

    XCTAssertTrue(qt.add(point: Point(1.5, 1.5)))

    let rect2 = Rect(origin: Point(0, 0), size: Size(xLength: 2, yLength: 2))
    XCTAssertTrue(qt.points(inRect: rect2) == [Point(1, 1), Point(0.5, 0.5), Point(1.5, 1.5)])
  }
}
