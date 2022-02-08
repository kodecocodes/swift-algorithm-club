//
//  DepthFirstIterative.swift
//  DFS
//
//  Created by Yash Jivani on 29/05/21.
//

import Foundation

func depthFirstSearchIterative(_ graph: Graph, source: Node) -> [String]{
    var nodesExplored = [source.label]
    
    source.visited = true
    
    var stack : [Node] = []
    
    stack.append(source)
    while(!stack.isEmpty){
        
        let top = stack.removeFirst()
        
        if(!top.visited){
            nodesExplored.append(top.label) 
            top.visited = true
        }
       
        for edge in top.neighbors{
            if(!edge.neighbor.visited){
                stack.insert(edge.neighbor, at: 0)
            }
        }
       
    }
    return nodesExplored
}
