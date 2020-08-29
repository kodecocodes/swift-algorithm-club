import Foundation

public func randomArrayOfSets<T>(covering universe: Set<T>,
                              minArraySizeFactor: Double = 0.8,
                              maxSetSizeFactor: Double = 0.6) -> Array<Set<T>> {
  var result = [Set<T>]()
  var ongoingUnion = Set<T>()

  let minArraySize = Int(Double(universe.count) * minArraySizeFactor)
  var maxSetSize = Int(Double(universe.count) * maxSetSizeFactor)
  if maxSetSize > universe.count {
    maxSetSize = universe.count
  }

  while true {
    var generatedSet = Set<T>()
    let targetSetSize = Int.random(in: 0...maxSetSize) + 1

    while true {
      let randomUniverseIndex = Int.random(in: 0...universe.count)
      for (setIndex, value) in universe.enumerated() {
        if setIndex == randomUniverseIndex {
          generatedSet.insert(value)
          break
        }
      }

      if generatedSet.count == targetSetSize {
        result.append(generatedSet)
        ongoingUnion = ongoingUnion.union(generatedSet)
        break
      }
    }

    if result.count >= minArraySize {
      if ongoingUnion == universe {
        break
      }
    }
  }

  return result
}
