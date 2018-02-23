# Genetic Algorthim

## What is it?

A genetic algorithm (GA) is process inspired by natural selection to find high quality solutions. Most commonly used for optimization. GAs rely on the bio-inspired processes of natural selection, more specifically the process of selection (fitness), mutation and crossover. To understand more, let's walk through these process in terms of biology:

### Selection
>**Selection**, in biology, the preferential survival and reproduction or preferential elimination of individuals with certain genotypes (genetic compositions), by means of natural or artificial controlling factors. [Britannica](britannica)

In other words, survival of the fittest. Organism that survive in their environment tend to reproduce more. With GAs we generate a fitness model that will rank offspring and give them a better chance for reproduction.

### Mutation
>**Mutation**, an alteration in the genetic material (the genome) of a cell of a living organism or of a virus that is more or less permanent and that can be transmitted to the cell’s or the virus’s descendants. [Britannica](https://www.britannica.com/science/mutation-genetics)

The randomization that allows for organisms to change over time. In GAs we build a randomization process that will mutate offspring in a populate in order to randomly introduce fitness variance.

### Crossover
>**Chromosomal crossover** (or crossing over) is the exchange of genetic material between homologous chromosomes that results in recombinant chromosomes during sexual reproduction [Wikipedia](https://en.wikipedia.org/wiki/Chromosomal_crossover)

Simply reproduction. A generation will a mixed representation of the previous generation, with offspring taking data (DNA) from both parents. GAs do this by randomly, but weightily, mating offspring to create new generations.

### Resources:
* [Wikipedia]()


## The Code

### Problem
For this quick and dirty example, we are going to obtain a optimize string using a simple genetic algorithm. More specifically we are trying to take a randomly generated origin string of a fixed length and evolve it into the most optimized string of our choosing.

We will be creating a bio-inspired world where the absolute existence is string `Hello, World!`. Nothing in this universe is better and it's our goal to get as close to it as possible.  

### Define the Universe

Before we dive into the core processes we need to set up our "universe". First let's define a lexicon, a set of everything that exists in our universe.

```swift
let lex: [UInt8] = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".asciiArray
```

To make things easier, we are actually going to work in ASCII values, so let's define a String extension to help with that.

```swift
extension String {
  var asciiArray: [UInt8] {
    return [UInt8](self.utf8)
  }
}
```

 Now, let's define a few global variables for the universe:

 ```swift
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
 ```

 The last piece we need for set up is a function to give us a random ASCII value from our lexicon:

 ```swift
 func randomChar(from lexicon: [UInt8]) -> UInt8 {
     let len = UInt32(lexicon.count-1)
     let rand = Int(arc4random_uniform(len))
     return lexicon[rand]
 }
 ```

 ### Population Zero

 Before selecting, mutating and reproduction, we need population to start with. Now that we have the universe defined we can write that function:

 ```swift
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
 ```

### Selection

There are two parts to the selection process, the first is calculating the fitness, which will assign a rating to a individual. We do this by simply calculating how close the individual is to the optimal string using ASCII values:

```swift
func calculateFitness(dna:[UInt8], optimal:[UInt8]) -> Int {
    var fitness = 0
    for c in 0...dna.count-1 {
        fitness += abs(Int(dna[c]) - Int(optimal[c]))
    }
    return fitness
}
```

The above is a very simple fitness calculation, but it'll work for our example. In a real world problem, the optimal solution is unknown or impossible. [Here](https://iccl.inf.tu-dresden.de/w/images/b/b7/GA_for_TSP.pdf) is a paper about optimizing a solution for the famous [traveling salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) using GA. In this example the problem is unsolvable by modern computers, but you can rate a individual solution by distance traveled. The optimal fitness here is an impossible 0. The closer the solution is to 0, the better chance for survival.

The second part to selection is weighted choice, also called roulette wheel selection. This defines how individuals are selected for the reproduction process out of the current population. Just because you are the best choice for natural selection doesn't mean the environment will select you. The individual could fall off a cliff, get dysentery or not be able to reproduce.

Let's take a second and ask why on this one. Why would you not always want to select the most fit from a population? It's hard to see from this simple example, but let's think about dog breeding, because breeders remove this process and hand select dogs for the next generation. As a result you get improved desired characteristics, but the individuals will also continue to carry genetic disorders that come along with those traits. This is essentially leading the evolution down a linear path. A certain "branch" of evolution may beat out the current fittest solution at a later time.

ok, back to code. Here is our weighted choice function:

```swift
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
```

The above function takes a list of individuals with their calculated fitness. Then selects one at random offset by their fitness value.

## Mutation

The all powerful mutation. The great randomization that turns bacteria into humans, just add time. So powerful yet so simple:

```swift
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
```

Takes a mutation chance and a individual and returns that individual with mutations, if any.

This allows for a population to explore all the possibilities of it's building blocks and randomly stumble on a better solution. If there is too much mutation, the evolution process will get nowhere. If there is too little the populations will become too similar and never be able to branch out of a defect to meet their changing environment.

## Crossover
