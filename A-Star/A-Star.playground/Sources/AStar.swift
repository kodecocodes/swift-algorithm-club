//
//  ASNode.swift
//  A-Star
//
//  Created by Vladyslav Yerofieiev on 3/10/17.
//  Copyright © 2017 Vladyslav Yerofieiev. All rights reserved.
//

import Foundation

open class ASNode: NSObject {
    
    /// Type of given node
    ///
    /// - free: we can find path on this node
    /// - busy: we can't find path on this node
    public enum NodeType {
        case free
        case busy
    }
    
    /// Parent node
    fileprivate var parent: ASNode? {
        didSet {
            if parent == self {
                
            }
        }
    }
    
    /// Node type - can be free where we can move, and busy where can't move
    open var type = NodeType.free
    
    /// X coord
    open var x: Int!
    
    /// Y Coord
    open var y: Int!
    
    //[15][10][15]
    //[10][__][10]
    //[15][10][15]
    
    /// Cost movement to current node
    fileprivate var cost: Int {
        get {
            guard let parentObject = self.parent else {
                return 0
            }
            if parentObject.x == self.x || parentObject.y == self.y {
                return parentObject.cost + 10
            } else {
                return parentObject.cost + 15
            }
        }
    }
    
    /// Calculate distance from this point to another
    ///
    /// - Parameter node: target node
    /// - Returns: Distance
    fileprivate func distance(to node: ASNode) -> Int {
        
        let dx = node.x-self.x
        let dy = node.y-self.y
        
        return Int(sqrt(Double(dx*dx+dy*dy)))
    }
    
    
    /// Check if this note is neighbor to another
    ///
    /// - Parameters:
    ///   - node: target node
    ///   - diagonally: enable check diagonally neighbors
    /// - Returns: is this point neighbor to target
    fileprivate func isNeighbor(to node: ASNode, diagonally: Bool) -> Bool {
        
        let isTop = node.x == self.x && node.y+1 == self.y
        let isBottom = node.x == self.x && node.y-1 == self.y
        let isLeft = node.x-1 == self.x && node.y == self.y
        let isRight = node.x+1 == self.x && node.y == self.y
        
        var diagonallyNeighbor = false
        
        if (diagonally) {
            let isTopRight = node.x+1 == self.x && node.y+1 == self.y
            let isTopLeft = node.x-1 == self.x && node.y+1 == self.y
            
            let isBottomRight = node.x+1 == self.x && node.y-1 == self.y
            let isBottomLeft = node.x-1 == self.x && node.y-1 == self.y
            diagonallyNeighbor =  isTopLeft || isTopRight || isBottomLeft || isBottomRight
        }
        
        return isTop || isBottom || isLeft || isRight || diagonallyNeighbor
    }
    
    public init(at pointX: Int, pointY: Int) {
        super.init()
        self.x = pointX
        self.y = pointY
    }
}

/// A* class
open class AStar: NSObject {
    
    /// Find path with given points
    ///
    /// - Parameters:
    ///   - startPoint: start path point
    ///   - endPoint: end path point
    ///   - nodes: all points of given field
    ///   - diagonally: enable check diagonally neighbors
    /// - Returns: path from start to end point if it exist
    open class func find(startPoint: ASNode, endPoint: ASNode, nodes: [ASNode], diagonally: Bool = true) -> [ASNode]? {
        var itemsList = nodes
        var openList = [ASNode]()
    
        openList.append(startPoint)
        var selectedPoint = startPoint
        itemsList.remove(at: nodes.index(of: selectedPoint)!)
        
        var pathFinded = false
        while !pathFinded {
            openList.remove(at: openList.index(of: selectedPoint)!)
            let neighbors = getNeighbors(from: selectedPoint, nodesList: itemsList, diagonally: diagonally)
            var lowCostNode: ASNode?
            var lowCost = Int.max
            
            for neighbor in neighbors {
                itemsList.remove(at: itemsList.index(of: neighbor)!)
                neighbor.parent = selectedPoint
                if neighbor == endPoint {
                    selectedPoint = endPoint
                    pathFinded = true
                    break
                }
                
                let cost = neighbor.cost + neighbor.distance(to: endPoint)
                
                if lowCost > cost {
                    lowCost = cost
                    lowCostNode = neighbor
                }
            }
            
            if !pathFinded {
                if lowCostNode != nil {
                    selectedPoint = lowCostNode!
                } else if openList.count > 0 {
                    selectedPoint = openList.first!
                } else {
                    return nil
                }
                openList.append(contentsOf: neighbors)
            }
        }
        
        var findedPath = [ASNode]()
        
        var pathNode: ASNode? = endPoint
        while pathNode != nil {
            findedPath.append(pathNode!)
            pathNode = pathNode?.parent
        }
        
        return findedPath.reversed()
    }
    
    
    /// Return nearest nodes from given
    ///
    /// - Parameters:
    ///   - node: current node
    ///   - nodesList: search neighbors list
    ///   - diagonally: enable check diagonally neighbors
    /// - Returns: all available neighbors
    fileprivate class func getNeighbors(from node: ASNode, nodesList:[ASNode], diagonally: Bool) -> [ASNode] {
        var returnList = [ASNode]()
        for currentNode in nodesList {
            if (currentNode.isNeighbor(to: node, diagonally: diagonally) && currentNode.type == .free) {
                returnList.append(currentNode)
            }
        }
        
        return returnList
    }
}
