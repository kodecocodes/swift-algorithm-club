//: Playground - noun: a place where people can play

import Foundation

extension String {
    var asciiArray: [UInt8] {
        return [UInt8](self.utf8)
    }
}


let lex: [UInt8] = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".asciiArray

// This is the end goal and what we will be using to rate fitness. In the real world this will not exist
let OPTIMAL:[UInt8] = "Hello, World".asciiArray

// The length of the string in our population. Organisms need to be similar
let DNA_SIZE = OPTIMAL.count

// size of each generation
let POP_SIZE = 50

// max number of generations, script will stop when it reach 5000 if the optimal value is not found
let GENERATIONS = 5000

// The chance in which a random nucleotide can mutate (1/n)
let MUTATION_CHANCE = 100

func randomChar(from lexicon: [UInt8]) -> UInt8 {
    let len = UInt32(lexicon.count-1)
    let rand = Int(arc4random_uniform(len))
    return lexicon[rand]
}

func randomPopulation(from lexicon: [UInt8], populationSize: Int, dnaSize: Int) -> [[UInt8]] {
    
    let len = UInt32(lexicon.count)
    
    var pop = [[UInt8]]()
    
    for _ in 0..<populationSize {
        var dna = [UInt8]()
        for _ in 0..<dnaSize {
            let char = randomChar(from: lexicon)
            dna.append(char)
        }
        pop.append(dna)
    }
    return pop
}

randomPopulation(from: lex, populationSize: POP_SIZE, dnaSize: DNA_SIZE)

func calculateFitness(dna:[UInt8], optimal:[UInt8]) -> Int {
    
    var fitness = 0
    for c in 0...dna.count-1 {
        fitness += abs(Int(dna[c]) - Int(optimal[c]))
    }
    return fitness
}

calculateFitness(dna: "Hillo, World".asciiArray, optimal: "Hello, World".asciiArray)

func weightedChoice(items:[(item:[UInt8], weight:Double)]) -> (item:[UInt8], weight:Double) {

    let total = items.reduce(0.0) { return $0 + $1.weight}
    
    var n = Double(arc4random_uniform(UInt32(total * 1000000.0))) / 1000000.0
    
    for itemTuple in items {
        if n < itemTuple.weight {
            return itemTuple
        }
        n = n - itemTuple.weight
    }
    return items[1]
}

func mutate(dna:[UInt8], mutationChance:Int) -> [UInt8] {
    var outputDna = dna
    
    for i in 0..<dna.count {
        let rand = Int(arc4random_uniform(UInt32(mutationChance)))
        if rand == 1 {
            outputDna[i] = randomChar()
        }
    }
    
    return outputDna
}
