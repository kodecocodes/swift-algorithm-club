// SetCover

let universe1 = Set(1...7)
let array1 = randomArrayOfSets(covering: universe1)
let cover1 = universe1.cover(within: array1)

let universe2 = Set(1...10)
let array2: Array<Set<Int>> = [[1, 2, 3, 4, 5, 6, 7], [8, 9]]
let cover2 = universe2.cover(within: array2)

let universe3 = Set(["tall", "heavy"])
let array3: Array<Set<String>> = [["tall", "light"], ["short", "heavy"], ["tall", "heavy", "young"]]
let cover3 = universe3.cover(within: array3)

let universe4 = Set(["tall", "heavy", "green"])
let cover4 = universe4.cover(within: array3)

let universe5: Set<Int> = [16, 32, 64]
let array5: Array<Set<Int>> = [[16, 17, 18], [16, 32, 128], [1, 2, 3], [32, 64, 128]]
let cover5 = universe5.cover(within: array5)

let universe6: Set<Int> = [24, 89, 132, 90, 22]
let array6 = randomArrayOfSets(covering: universe6)
let cover6 = universe6.cover(within: array6)

let universe7: Set<String> = ["fast", "cheap", "good"]
let array7 = randomArrayOfSets(covering: universe7, minArraySizeFactor: 20.0, maxSetSizeFactor: 0.7)
let cover7 = universe7.cover(within: array7)

let emptySet = Set<Int>()
let coverTest1 = emptySet.cover(within: array1)
let coverTest2 = universe1.cover(within: Array<Set<Int>>())
let coverTest3 = emptySet.cover(within: Array<Set<Int>>())


