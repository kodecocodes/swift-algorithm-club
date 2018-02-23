/*
  base .. to be refactored
*/

import Foundation

// HELPERS
/*
    String extension to convert a string to ascii value
*/
extension String {
    var asciiArray: [UInt8] {
        return unicodeScalars.filter{$0.isASCII}.map{UInt8($0.value)}
    }
}

let lex = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".map {  }

/*
    helper function to return a random character string
*/
func randomChar() -> UInt8 {

    let letters : [UInt8] = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".asciiArray
    let len = UInt32(letters.count-1)

    let rand = Int(arc4random_uniform(len))
    return letters[rand]
}

// END HELPERS

let OPTIMAL:[UInt8] = "Hello, World".asciiArray
let DNA_SIZE = OPTIMAL.count
let POP_SIZE = 50
let GENERATIONS = 5000
let MUTATION_CHANCE = 100

/*
    calculated the fitness based on approximate string matching
    compares each character ascii value difference and adds that to a total fitness
    optimal string comparsion = 0
*/
func calculateFitness(dna:[UInt8], optimal:[UInt8]) -> Int {

    var fitness = 0
    for c in 0...dna.count-1 {
        fitness += abs(Int(dna[c]) - Int(optimal[c]))
    }
    return fitness
}

/*
    randomly mutate the string
*/
func mutate(dna:[UInt8], mutationChance:Int, dnaSize:Int) -> [UInt8] {
    var outputDna = dna

    for i in 0..<dnaSize {
        let rand = Int(arc4random_uniform(UInt32(mutationChance)))
        if rand == 1 {
            outputDna[i] = randomChar()
        }
    }

    return outputDna
}

/*
    combine two parents to create an offspring
    parent = xy & yx, offspring = xx, yy
*/
func crossover(dna1:[UInt8], dna2:[UInt8], dnaSize:Int) -> (dna1:[UInt8], dna2:[UInt8]) {
    let pos = Int(arc4random_uniform(UInt32(dnaSize-1)))

    let dna1Index1 = dna1.index(dna1.startIndex, offsetBy: pos)
    let dna2Index1 = dna2.index(dna2.startIndex, offsetBy: pos)

    return (
        [UInt8](dna1.prefix(upTo: dna1Index1) + dna2.suffix(from: dna2Index1)),
        [UInt8](dna2.prefix(upTo: dna2Index1) + dna1.suffix(from: dna1Index1))
    )
}


/*
returns a random population, used to start the evolution
*/
func randomPopulation(populationSize: Int, dnaSize: Int) -> [[UInt8]] {

    let letters : [UInt8] = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".asciiArray
    let len = UInt32(letters.count)

    var pop = [[UInt8]]()

    for _ in 0..<populationSize {
        var dna = [UInt8]()
        for _ in 0..<dnaSize {
            let rand = arc4random_uniform(len)
            let nextChar = letters[Int(rand)]
            dna.append(nextChar)
        }
        pop.append(dna)
    }
    return pop
}


/*
function to return random canidate of a population randomally, but weight on fitness.
*/
func weightedChoice(items:[(item:[UInt8], weight:Double)]) -> (item:[UInt8], weight:Double) {
    var weightTotal = 0.0
    for itemTuple in items {
        weightTotal += itemTuple.weight;
    }

    var n = Double(arc4random_uniform(UInt32(weightTotal * 1000000.0))) / 1000000.0

    for itemTuple in items {
        if n < itemTuple.weight {
            return itemTuple
        }
        n = n - itemTuple.weight
    }
    return items[1]
}

func main() {

    // generate the starting random population
    var population:[[UInt8]] = randomPopulation(populationSize: POP_SIZE, dnaSize: DNA_SIZE)
    // print("population: \(population), dnaSize: \(DNA_SIZE) ")
    var fittest = [UInt8]()

    for generation in 0...GENERATIONS {
        print("Generation \(generation) with random sample: \(String(bytes: population[0], encoding:.ascii)!)")

        var weightedPopulation = [(item:[UInt8], weight:Double)]()

        // calulcated the fitness of each individual in the population
        // and add it to the weight population (weighted = 1.0/fitness)
        for individual in population {
            let fitnessValue = calculateFitness(dna: individual, optimal: OPTIMAL)

            let pair = ( individual, fitnessValue == 0 ? 1.0 : 1.0/Double( fitnessValue ) )

            weightedPopulation.append(pair)
        }

        population = []

        // create a new generation using the individuals in the origional population
        for _ in 0...POP_SIZE/2 {
            let ind1 = weightedChoice(items: weightedPopulation)
            let ind2 = weightedChoice(items: weightedPopulation)

            let offspring = crossover(dna1: ind1.item, dna2: ind2.item, dnaSize: DNA_SIZE)

            // append to the population and mutate
            population.append(mutate(dna: offspring.dna1, mutationChance: MUTATION_CHANCE, dnaSize: DNA_SIZE))
            population.append(mutate(dna: offspring.dna2, mutationChance: MUTATION_CHANCE, dnaSize: DNA_SIZE))
        }

        fittest = population[0]
        var minFitness = calculateFitness(dna: fittest, optimal: OPTIMAL)

        // parse the population for the fittest string
        for indv in population {
            let indvFitness = calculateFitness(dna: indv, optimal: OPTIMAL)
            if indvFitness < minFitness {
                fittest = indv
                minFitness = indvFitness
            }
        }
        if minFitness == 0 { break; }
    }
    print("fittest string: \(String(bytes: fittest, encoding: .ascii)!)")
}

main()
