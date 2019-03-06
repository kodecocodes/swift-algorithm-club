

extension String {
  
  var unicodeArray: [UInt8] {
    return [UInt8](self.utf8)
  }
}

let lex: [UInt8] = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".unicodeArray

// This is the end goal and what we will be using to rate fitness. In the real world this will not exist
let OPTIMAL:[UInt8] = "Hello, World".unicodeArray

// The length of the string in our population. Organisms need to be similar
let DNA_SIZE = OPTIMAL.count

// Size of each generation
let POP_SIZE = 50

// Max number of generations, script will stop when it reaches 5000 if the optimal value is not found
let GENERATIONS = 5000

// The chance in which a random nucleotide can mutate (1/n)
let MUTATION_CHANCE = 100

func randomPopulation(from lexicon: [UInt8], populationSize: Int, dnaSize: Int) -> [[UInt8]] {
  var pop = [[UInt8]]()
  
  (0..<populationSize).forEach { _ in
    var dna = [UInt8]()
    (0..<dnaSize).forEach { _ in
      let char = lexicon.randomElement()!
      dna.append(char)
    }
    pop.append(dna)
  }
  return pop
}

func calculateFitness(dna: [UInt8], optimal: [UInt8]) -> Int {
  var fitness = 0
  for index in dna.indices {
    fitness += abs(Int(dna[index]) - Int(optimal[index]))
  }
  return fitness
}

func weightedChoice(items: [(dna: [UInt8], weight: Double)]) -> (dna: [UInt8], weight: Double) {
  
  let total = items.reduce(0) { $0 + $1.weight }
  var n = Double.random(in: 0..<(total * 1000000)) / 1000000.0
  
  for item in items {
    if n < item.weight {
      return item
    }
    n = n - item.weight
  }
  return items[1]
}

func mutate(lexicon: [UInt8], dna: [UInt8], mutationChance: Int) -> [UInt8] {
  var outputDna = dna
  (0..<dna.count).forEach { i in
    let rand = Int.random(in: 0..<mutationChance)
    if rand == 1 {
      outputDna[i] = lexicon.randomElement()!
    }
  }
  
  return outputDna
}

func crossover(dna1: [UInt8], dna2: [UInt8], dnaSize: Int) -> [UInt8] {
  let pos = Int.random(in: 0..<dnaSize)
  
  let dna1Index1 = dna1.index(dna1.startIndex, offsetBy: pos)
  let dna2Index1 = dna2.index(dna2.startIndex, offsetBy: pos)
  
  return [UInt8](dna1.prefix(upTo: dna1Index1) + dna2.suffix(from: dna2Index1))
}

var population: [[UInt8]] = randomPopulation(from: lex, populationSize: POP_SIZE, dnaSize: DNA_SIZE)
var fittest = population[0]
import Foundation

func main() {
  for generation in 0...GENERATIONS {
    var weightedPopulation = [(dna: [UInt8], weight: Double)]()
    
    for individual in population {
      let fitnessValue = calculateFitness(dna: individual, optimal: OPTIMAL)
      let pair = (individual, fitnessValue == 0 ? 1.0 : 1.0/Double(fitnessValue))
      weightedPopulation.append(pair)
    }
    
    population = []
    
    (0...POP_SIZE).forEach { _ in
      let ind1 = weightedChoice(items: weightedPopulation)
      let ind2 = weightedChoice(items: weightedPopulation)
      
      let offspring = crossover(dna1: ind1.dna, dna2: ind2.dna, dnaSize: DNA_SIZE)
      population.append(mutate(lexicon: lex, dna: offspring, mutationChance: MUTATION_CHANCE))
    }
    
    fittest = population[0]
    var minFitness = calculateFitness(dna: fittest, optimal: OPTIMAL)
    
    population.forEach { indv in
      let indvFitness = calculateFitness(dna: indv, optimal: OPTIMAL)
      if indvFitness < minFitness {
        fittest = indv
        minFitness = indvFitness
      }
    }
    
    if minFitness == 0 { break }
    print("\(generation): \(String(bytes: fittest, encoding: .utf8)!)")
  }
  print("fittest string: \(String(bytes: fittest, encoding: .utf8)!)")
}
main()
