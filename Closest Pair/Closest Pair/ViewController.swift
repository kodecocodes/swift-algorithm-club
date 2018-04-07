//
//  ViewController.swift
//  Closest Pair
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 ahmednader. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "Input", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let strings = data.components(separatedBy: .whitespacesAndNewlines)
                var myStrings = strings.split(separator: "")
                
                var i=0
                while i < myStrings.count {
                    var array = [Point]()
                    let num = Int(myStrings[i].first!)!
                    
                    if num == 0 { print(); break }
                    
                    for _ in 0..<num {
                        array.append(Point(x: Double(Int(myStrings[i+1].first!)!) , y: Double(Int(myStrings[i+1][myStrings[i+1].startIndex+1])!) ))
                        i+=1
                    }
                    i+=1
                    
                    var sortedArray = mergeSort(array,true)
                    let min = ClosestPair(&sortedArray, sortedArray.count)
                    
                    
                    if min > 10000 {
                        print("INFINITY")
                    } else {
                        print(String(format: "%.4f",  min))
                    }
                }
                
            } catch {
                print(error)
            }
        }
    }


}

