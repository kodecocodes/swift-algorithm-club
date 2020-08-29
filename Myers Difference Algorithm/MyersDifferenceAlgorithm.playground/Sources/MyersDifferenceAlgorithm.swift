//
//  MyersDifferenceAlgorithm.swift
//
//  Created by Yuya Horita on 2018/02/27.
//  Copyright © 2018年 hy. All rights reserved.
//

import Foundation

public struct MyersDifferenceAlgorithm<E: Equatable> {
    public static func calculateShortestEditDistance(from fromArray: Array<E>, to toArray: Array<E>) -> Int {
        let fromCount = fromArray.count
        let toCount = toArray.count
        let totalCount = toCount + fromCount
        var furthestReaching = Array(repeating: 0, count: 2 * totalCount + 1)
        
        let isReachedAtSink: (Int, Int) -> Bool = { x, y in
            return x == fromCount && y == toCount
        }
        
        let snake: (Int, Int, Int) -> Int = { x, D, k in
            var _x = x
            while _x < fromCount && _x - k < toCount && fromArray[_x] == toArray[_x - k] {
                _x += 1
            }
            return _x
        }
        
        for D in 0...totalCount {
            for k in stride(from: -D, through: D, by: 2) {
                let index = k + totalCount
                
                // (x, D, k) => the x position on the k_line where the number of scripts is D
                // scripts means insertion or deletion
                var x = 0
                if D == 0 { }
                    // k == -D, D will be the boundary k_line
                    // when k == -D, moving right on the Edit Graph(is delete script) from k - 1_line where D - 1 is unavailable.
                    // when k == D, moving bottom on the Edit Graph(is insert script) from k + 1_line where D - 1 is unavailable.
                    // furthestReaching x position has higher calculating priority. (x, D - 1, k - 1), (x, D - 1, k + 1)
                else if k == -D || k != D && furthestReaching[index - 1] < furthestReaching[index + 1] {
                    // Getting initial x position
                    // ,using the furthestReaching X position on the k + 1_line where D - 1
                    // ,meaning get (x, D, k) by (x, D - 1, k + 1) + moving bottom + snake
                    // this moving bottom on the edit graph is compatible with insert script
                    x = furthestReaching[index + 1]
                } else {
                    // Getting initial x position
                    // ,using the futrhest X position on the k - 1_line where D - 1
                    // ,meaning get (x, D, k) by (x, D - 1, k - 1) + moving right + snake
                    // this moving right on the edit graph is compatible with delete script
                    x = furthestReaching[index - 1] + 1
                }
                
                // snake
                // diagonal moving can be performed with 0 cost.
                // `same` script is needed ?
                let _x = snake(x, D, k)
                
                if isReachedAtSink(_x, _x - k) { return D }
                furthestReaching[index] = _x
            }
        }
        
        fatalError("Never comes here")
    }
}
