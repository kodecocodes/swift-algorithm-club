public func drop(numberOfEggs: Int, numberOfFloors: Int) -> Int {
  guard numberOfEggs != 0 && numberOfFloors != 0 else { return 0 }
  guard numberOfEggs != 1 && numberOfFloors != 1 else { return 1 }
  
  var eggFloor: [[Int]] = .init(repeating: .init(repeating: 0, count: numberOfFloors + 1), count: numberOfEggs + 1)
  var attempts = 0
  
  for floorNumber in stride(from: 0, through: numberOfFloors, by: 1) {
    eggFloor[1][floorNumber] = floorNumber
  }
  eggFloor[2][1] = 1
  
  for eggNumber in stride(from: 2, through: numberOfEggs, by: 1) {
    for floorNumber in stride(from: 2, through: numberOfFloors, by: 1) {
      eggFloor[eggNumber][floorNumber] = Int.max
      for visitingFloor in stride(from: 1, through: floorNumber, by: 1) {
        attempts = 1 + max(eggFloor[eggNumber - 1][visitingFloor - 1], eggFloor[eggNumber][floorNumber - visitingFloor])
        
        if attempts < eggFloor[eggNumber][floorNumber] {
          eggFloor[eggNumber][floorNumber] = attempts
        }
      }
    }
  }
  
  return eggFloor[numberOfEggs][numberOfFloors]
}
