public func eggDrop(numberOfEggs: Int, numberOfFloors: Int) -> Int {
    if numberOfEggs == 0 || numberOfFloors == 0{ //edge case: When either number of eggs or number of floors is 0, answer is 0
        return 0
    }
    if numberOfEggs == 1 || numberOfFloors == 1{ //edge case: When either number of eggs or number of floors is 1, answer is 1
        return 1
    }
    
    var eggFloor = [[Int]](repeating: [Int](repeating: 0, count: numberOfFloors+1), count: numberOfEggs+1) //egg(rows) floor(cols) array to store the solutions
    var attempts: Int = 0
    
    for var floorNumber in (0..<(numberOfFloors+1)){
        eggFloor[1][floorNumber] = floorNumber      //base case: if there's only one egg, it takes 'numberOfFloors' attempts
    }
    eggFloor[2][1] = 1 //base case: if there are two eggs and one floor, it takes one attempt
    
    for var eggNumber in (2..<(numberOfEggs+1)){
        for var floorNumber in (2..<(numberOfFloors+1)){
            eggFloor[eggNumber][floorNumber] = Int.max   //setting the final result a high number to find out minimum
            for var visitingFloor in (1..<(floorNumber+1)){
                //there are two cases
                //case 1: egg breaks. meaning we'll have one less egg, and we'll have to go downstairs -> visitingFloor-1
                //case 2: egg doesn't break. meaning we'll still have 'eggs' number of eggs, and we'll go upstairs -> floorNumber-visitingFloor
                attempts = 1 + max(eggFloor[eggNumber-1][visitingFloor-1], eggFloor[eggNumber][floorNumber-visitingFloor])//we add one taking into account the attempt we're taking at the moment
                
                if attempts < eggFloor[eggNumber][floorNumber]{ //finding the min
                    eggFloor[eggNumber][floorNumber] = attempts;
                }
            }
        }
    }
    
    return eggFloor[numberOfEggs][numberOfFloors]
}

//Helper function to find max of two integers
public func max(_ x1: Int, _ x2: Int) -> Int{
    return x1 > x2 ? x1 : x2
}
