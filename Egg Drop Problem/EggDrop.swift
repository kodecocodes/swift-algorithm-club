func eggDrop(_ numberOfEggs: Int, numberOfFloors: Int) -> Int {
    var eggFloor: [[Int]] = [] //egg(rows) floor(cols) array to store the solutions
    var attempts: Int = 0
    
    for var i in (0..<numberOfFloors){
        eggFloor[1][i] = i
    }
    eggFloor[2][1] = 1
    
    for var i in (2..<=numberOfEggs){
        for var j in (2..numberOfFloors){
            eggFloor[i][j] = 1000000
            for var k in (1..<=j){
                //there are two cases
                //case 1: egg breaks. meaning we'll have one less egg, and we'll have to go downstairs -> k-1
                //case 2: egg doesn't break. meaning we'll still have 'i' number of eggs, and we'll go upstairs -> j-k
                attempts = 1 + max(eggFloor[i-1][k-1], eggFloor[i][j-k])//we add one taking into account the attempt we're taking at the moment
                
                if attempts < eggFloor[i][j]{ //finding the min
                    eggFloor[i][j] = attempts;
                }
            }
        }
    }
    
    return eggFloor[numberOfEggs][numberOfFloors]
}

func max(_ x1: Int, _ x2: Int){
    return x1 > x2 ? x1 : x2
}
