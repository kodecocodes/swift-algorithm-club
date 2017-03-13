//
//  Array2DTest.swift
//  algorithmclub
//
//  Created by Barbara Rodeker on 2/16/16.
//  Copyright © 2016 Swift Algorithm Club. All rights reserved.
//

import XCTest

class AStarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPathFind2Way() {
        let testData = ["⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️",
                        "⚪️","⚫️","⚪️","⚫️","⚪️","⚫️","⚪️",
                        "⚪️","⚫️","⚪️","⚫️","🔵","⚫️","⚪️",
                        "⚪️","⚪️","⚪️","⚫️","⚫️","⚪️","⚪️",
                        "🔴","⚫️","⚪️","⚪️","⚪️","⚪️","⚪️"]
        
        let testPoints = self.fillNodes(from: testData)
        let path = AStar.find(startPoint: testPoints.start, endPoint: testPoints.end, nodes: testPoints.points)
       
        XCTAssertNotNil(path)
        XCTAssertEqual(path?.count, 7)
        
        for item in path! {
            XCTAssertEqual(item.type, .free)
        }
        
        XCTAssertEqual(path?.first, testPoints.start)
        XCTAssertEqual(path?.last, testPoints.end)
    }
    
    func testPathFindWrong() {
        let testData = ["⚪️","⚫️","⚫️","⚪️","⚪️","⚪️","⚪️",
                        "⚪️","⚪️","⚫️","⚪️","⚪️","⚫️","⚪️",
                        "⚪️","⚪️","⚫️","⚪️","🔵","⚫️","⚪️",
                        "⚪️","⚫️","⚫️","⚫️","⚫️","⚪️","⚪️",
                        "🔴","⚫️","⚪️","⚪️","⚪️","⚪️","⚪️"]
        
        let testPoints = self.fillNodes(from: testData)
        let path = AStar.find(startPoint: testPoints.start, endPoint: testPoints.end, nodes: testPoints.points)
        
        XCTAssertNil(path)

    }
    
    func testPathFindNear() {
        let testData = ["⚪️","⚫️","⚫️","⚪️","⚪️","⚪️","⚪️",
                        "⚪️","⚪️","⚫️","⚪️","⚪️","⚫️","⚪️",
                        "⚪️","⚪️","⚫️","⚪️","⚪️","⚫️","⚪️",
                        "🔵","⚫️","⚫️","⚫️","⚫️","⚪️","⚪️",
                        "🔴","⚫️","⚪️","⚪️","⚪️","⚪️","⚪️"]
        
        let testPoints = self.fillNodes(from: testData)
        let path = AStar.find(startPoint: testPoints.start, endPoint: testPoints.end, nodes: testPoints.points)
        
        XCTAssertNotNil(path)
        XCTAssertEqual(path?.count, 2)
        XCTAssertEqual(path?.first, testPoints.start)
        XCTAssertEqual(path?.last, testPoints.end)
        
    }
    
    func testPathFindSnake() {
        let testData = ["⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","🔵",
                        "⚪️","⚫️","⚫️","⚫️","⚫️","⚫️","⚫️",
                        "⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️",
                        "⚫️","⚫️","⚫️","⚫️","⚫️","⚫️","⚪️",
                        "🔴","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️"]
        
        let testPoints = self.fillNodes(from: testData)
        
        let path1 = AStar.find(startPoint: testPoints.start, endPoint: testPoints.end, nodes: testPoints.points)
        
        XCTAssertNotNil(path1)
        XCTAssertEqual(path1?.count, 19)
        XCTAssertEqual(path1?.first, testPoints.start)
        XCTAssertEqual(path1?.last, testPoints.end)
        
        let path2 = AStar.find(startPoint: testPoints.start, endPoint: testPoints.end, nodes: testPoints.points, diagonally: false)
        
        XCTAssertNotNil(path2)
        XCTAssertEqual(path2?.count, 23)
        XCTAssertEqual(path2?.first, testPoints.start)
        XCTAssertEqual(path2?.last, testPoints.end)
        
    }
    
    func testPathFindAllFree() {
        let testData = ["⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","🔵",
                        "⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️",
                        "⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️",
                        "⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️",
                        "🔴","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️"]
        
        let testPoints = self.fillNodes(from: testData)
        let path = AStar.find(startPoint: testPoints.start, endPoint: testPoints.end, nodes: testPoints.points)
        
        XCTAssertNotNil(path)
        
        XCTAssertEqual(path?.first, testPoints.start)
        XCTAssertEqual(path?.last, testPoints.end)
    }
    
    func testPeformance() {
        let testData = ["⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️",
                        "⚪️","⚫️","⚪️","⚫️","⚪️","⚪️","⚪️",
                        "⚪️","⚫️","⚪️","⚫️","⚫️","⚫️","⚪️",
                        "⚪️","⚫️","⚪️","⚫️","🔵","⚫️","⚪️",
                        "🔴","⚫️","⚪️","⚪️","⚪️","⚪️","⚪️"]
        
        let testPoints = self.fillNodes(from: testData)
        measure {
            for _ in 0...100 {
                let _ = AStar.find(startPoint: testPoints.start, endPoint: testPoints.end, nodes: testPoints.points)
            }
        }
    }
    
    fileprivate func fillNodes(from data:[String]) -> (start: ASNode, end: ASNode, points: [ASNode]) {
        var points = [ASNode]()
        
        var startPoint: ASNode!
        var endPoint: ASNode!
        
        for x in 0..<7 {
            for y in 0..<5 {
                let symbol = data[y*7+x]
                let node = ASNode.init(at: x, pointY: y)
                switch symbol {
                case "🔴":
                    startPoint = node
                    break
                case "🔵":
                    endPoint = node
                    break
                case "⚫️":
                    node.type = .busy
                    break
                default:
                    break
                }
                points.append(node)
            }
        }
        
        return (startPoint, endPoint, points)
    }
}
