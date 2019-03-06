# Genetic Algorthim

## What is it?

A genetic algorithm (GA) is process inspired by natural selection to find high quality solutions. Most commonly used for optimization. GAs rely on the bio-inspired processes of natural selection, more specifically the process of selection (fitness), crossover and mutation. To understand more, let's walk through these processes in terms of biology:

### Selection
>**Selection**, in biology, the preferential survival and reproduction or preferential elimination of individuals with certain genotypes (genetic compositions), by means of natural or artificial controlling factors.

In other words, survival of the fittest. Organisms that survive in their environment tend to reproduce more. With GAs we generate a fitness model that will rank individuals and give them a better chance for reproduction.

### Crossover
>**Chromosomal crossover** (or crossing over) is the exchange of genetic material between homologous chromosomes that results in recombinant chromosomes during sexual reproduction [Wikipedia](https://en.wikipedia.org/wiki/Chromosomal_crossover)

Simply reproduction. A generation will be a mixed representation of the previous generation, with offspring taking DNA from both parents. GAs do this by randomly, but weightily, mating offspring to create new generations.

### Mutation
>**Mutation**, an alteration in the genetic material (the genome) of a cell of a living organism or of a virus that is more or less permanent and that can be transmitted to the cell’s or the virus’s descendants. [Britannica](https://www.britannica.com/science/mutation-genetics)

The randomization that allows for organisms to change over time. In GAs we build a randomization process that will mutate offspring in a population in order to introduce fitness variance.

### Resources:
* [Genetic Algorithms in Search Optimization, and Machine Learning](https://www.amazon.com/Genetic-Algorithms-Optimization-Machine-Learning/dp/0201157675/ref=sr_1_sc_1?ie=UTF8&qid=1520628364&sr=8-1-spell&keywords=Genetic+Algortithms+in+search)
* [Wikipedia](https://en.wikipedia.org/wiki/Genetic_algorithm)
* [My Original Gist](https://gist.github.com/blainerothrock/efda6e12fe10792c99c990f8ff3daeba)

## The Code

### Problem
For this quick and dirty example, we are going to produce an optimized string using a simple genetic algorithm. More specifically we are trying to take a randomly generated origin string of a fixed length and evolve it into the most optimized string of our choosing.

We will be creating a bio-inspired world where the absolute existence is the string `Hello, World!`. Nothing in this universe is better and it's our goal to get as close to it as possible to ensure survival.

### Define the Universe

Before we dive into the core processes we need to set up our "universe". First let's define a lexicon, a set of everything that exists in our universe.

```swift
let lex: [UInt8] = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".asciiArray
```

To make things easier, we are actually going to work in [Unicode values](https://en.wikipedia.org/wiki/List_of_Unicode_characters), so let's define a String extension to help with that.

```swift
extension String {
  var unicodeArray: [UInt8] {
    return [UInt8](self.utf8)
  }
}
```

 Now, let's define a few global variables for the universe:
 * `OPTIMAL`: This is the end goal and what we will be using to rate fitness. In the real world this will not exist
 * `DNA_SIZE`: The length of the string in our population. Organisms need to be similar
 * `POP_SIZE`: Size of each generation
 * `MAX_GENERATIONS`: Max number of generations, script will stop when it reach 5000 if the optimal value is not found
 * `MUTATION_CHANCE`: The chance in which a random nucleotide can mutate (`1/MUTATION_CHANCE`)

 ```swift
let OPTIMAL:[UInt8] = "Hello, World".unicodeArray
let DNA_SIZE = OPTIMAL.count
let POP_SIZE = 50
let GENERATIONS = 5000
let MUTATION_CHANCE = 100
 ```

 ### Population Zero

Before selecting, crossover and mutation, we need a population to start with. Now that we have the universe defined we can write that function:

 ```swift
 func randomPopulation(from lexicon: [UInt8], populationSize: Int, dnaSize: Int) -> [[UInt8]] {
    guard lexicon.count > 1 else { return [] }
    var pop = [[UInt8]]()

    (0..<populationSize).forEach { _ in
        var dna = [UInt8]()
        (0..<dnaSize).forEach { _ in
            let char = lexicon.randomElement()! // guaranteed to be non-nil by initial guard statement
            dna.append(char)
        }
        pop.append(dna)
    }
    return pop
 }
 ```

### Selection

There are two parts to the selection process, the first is calculating the fitness, which will assign a rating to a individual. We do this by simply calculating how close the individual is to the optimal string using unicode values:

```swift
func calculateFitness(dna: [UInt8], optimal: [UInt8]) -> Int {
    guard dna.count == optimal.count else { return -1 }
    var fitness = 0
    for index in dna.indices {
        fitness += abs(Int(dna[index]) - Int(optimal[index]))
    }
    return fitness
}
```

The above will produce a fitness value to an individual. The perfect solution, "Hello, World" will have a fitness of 0. "Gello, World" will have a fitness of 1 since it is one unicode value off from the optimal (`H->G`).

This example is very simple, but it'll work for our example. In a real world problem, the optimal solution is unknown or impossible. [Here](https://iccl.inf.tu-dresden.de/w/images/b/b7/GA_for_TSP.pdf) is a paper about optimizing a solution for the famous [traveling salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) using a GA. In this example the problem is unsolvable by modern computers, but you can rate a individual solution by distance traveled. The optimal fitness here is an impossible 0. The closer the solution is to 0, the better chance for survival. In our example we will reach our goal, a fitness of 0.

The second part to selection is weighted choice, also called roulette wheel selection. This defines how individuals are selected for the reproduction process out of the current population. Just because you are the best choice for natural selection doesn't mean the environment will select you. The individual could fall off a cliff, get dysentery or be unable to reproduce.

Let's take a second and ask why on this one. Why would you not always want to select the most fit from a population? It's hard to see from this simple example, but let's think about dog breeding, because breeders remove this process and hand select dogs for the next generation. As a result you get improved desired characteristics, but the individuals will also continue to carry genetic disorders that come along with those traits. A certain "branch" of evolution may beat out the current fittest solution at a later time. This may be ok depending on the problem, but to keep this educational we will go with the bio-inspired way.

With all that, here is our weight choice function:

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


The above function takes a list of individuals with their calculated fitness. Then selects one at random offset by their fitness value. The horrible 1,000,000 multiplication and division is to insure precision by calculating decimals. `Double.random` only uses integers so this is required to convert to a precise Double, it's not perfect, but enough for our example.

## Mutation

The all powerful mutation, the thing that introduces otherwise non existent fitness variance. It can either hurt of improve a individuals fitness but over time it will cause evolution towards more fit populations. Imagine if our initial random population was missing the charachter `H`, in that case we need to rely on mutation to introduce that character into the population in order to achieve the optimal solution.

```swift
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
```

Takes a mutation chance and a individual and returns that individual with mutations, if any.

This allows for a population to explore all the possibilities of it's building blocks and randomly stumble on a better solution. If there is too much mutation, the evolution process will get nowhere. If there is too little the populations will become too similar and never be able to branch out of a defect to meet their changing environment.

## Crossover

Crossover, the sexy part of a GA, is how offspring are created from 2 selected individuals in the current population. This is done by splitting the parents into 2 parts, then combining 1 part from each parent to create the offspring. To promote diversity, we randomly select a index to split the parents.

```swift
func crossover(dna1: [UInt8], dna2: [UInt8], dnaSize: Int) -> [UInt8] {
    let pos = Int.random(in: 0..<dnaSize)
    
    let dna1Index1 = dna1.index(dna1.startIndex, offsetBy: pos)
    let dna2Index1 = dna2.index(dna2.startIndex, offsetBy: pos)
    
    return [UInt8](dna1.prefix(upTo: dna1Index1) + dna2.suffix(from: dna2Index1))
}
```

The above is used to generate a completely new generation based on the current generation.

## Putting it all together -- Running the Genetic Algorithm

We now have all the functions we need to kick off the algorithm. Let's start from the beginning, first we need a random population to serve as a starting point. We will also initialize a fittest variable to hold the fittest individual, we will initialize it with the first individual of our random population.

```swift
var population:[[UInt8]] = randomPopulation(from: lex, populationSize: POP_SIZE, dnaSize: DNA_SIZE)
var fittest = population[0]
```

Now for the meat, the remainder of the code will take place in the generation loop, running once for every generation:

```swift
for generation in 0...GENERATIONS {
  // run
}
```

Now, for each individual in the population, we need to calculate its fitness and weighted value. Since 0 is the best value we will use `1/fitness` to represent the weight. Note this is not a percent, but just how much more likely the value is to be selected over others. If the highest number was the most fit, the weight calculation would be `fitness/totalFitness`, which would be a percent.

```swift
var weightedPopulation = [(dna:[UInt8], weight:Double)]()

for individual in population {
  let fitnessValue = calculateFitness(dna: individual, optimal: OPTIMAL)
  let pair = ( individual, fitnessValue == 0 ? 1.0 : 1.0/Double( fitnessValue ) )
  weightedPopulation.append(pair)
}
```

From here we can start to build the next generation.

```swift
var nextGeneration = []
```

The below loop is where we pull everything together. We loop for `POP_SIZE`, selecting 2 individuals by weighted choice, crossover their values to produce a offspring, then finial subject the new individual to mutation. Once completed we have a completely new generation based on the last generation.

```swift
0...POP_SIZE).forEach { _ in
    let ind1 = weightedChoice(items: weightedPopulation)
    let ind2 = weightedChoice(items: weightedPopulation)

    let offspring = crossover(dna1: ind1.dna, dna2: ind2.dna, dnaSize: DNA_SIZE)

    // append to the population and mutate
    nextGeneration.append(mutate(lexicon: lex, dna: offspring, mutationChance: MUTATION_CHANCE))
}
```

The final piece to the main loop is to select the fittest individual of a population:

```swift
fittest = population[0]
var minFitness = calculateFitness(dna: fittest, optimal: OPTIMAL)

population.forEach { indv in
    let indvFitness = calculateFitness(dna: indv, optimal: OPTIMAL)
    if indvFitness < minFitness {
        fittest = indv
        minFitness = indvFitness
    }
}
if minFitness == 0 { break; }
print("\(generation): \(String(bytes: fittest, encoding: .utf8)!)")
```

Since we know the fittest string, I've added a `break` to kill the program if we find it. At the end of a loop add a print statement for the fittest string:

```swift
print("fittest string: \(String(bytes: fittest, encoding: .utf8)!)")
```

Now we can run the program! Playgrounds are a nice place to develop, but are going to run this program **very slow**. I highly suggest running in Terminal: `swift gen.swift`. When running you should see something like this and it should not take too long to get `Hello, World`:

```text
0: RXclh F HDko
1: DkyssjgElk];
2: TiM4u) DrKvZ
3: Dkysu) DrKvZ
4: -kysu) DrKvZ
5: Tlwsu) DrKvZ
6: Tlwsu) Drd}k
7: Tlwsu) Drd}k
8: Tlwsu) Drd}k
9: Tlwsu) Drd}k
10: G^csu) |zd}k
11: G^csu) |zdko
12: G^csu) |zdko
13: Dkysu) Drd}k
14: G^wsu) `rd}k
15: Dkysu) `rdko
16: Dkysu) `rdko
17: Glwsu) `rdko
18: TXysu) `rdkc
19: U^wsu) `rdko
20: G^wsu) `rdko
21: Glysu) `rdko
22: G^ysu) `rdko
23: G^ysu) `ryko
24: G^wsu) `rdko
25: G^wsu) `rdko
26: G^wsu) `rdko
...
1408: Hello, Wormd
1409: Hello, Wormd
1410: Hello, Wormd
1411: Hello, Wormd
1412: Hello, Wormd
1413: Hello, Wormd
1414: Hello, Wormd
1415: Hello, Wormd
1416: Hello, Wormd
1417: Hello, Wormd
1418: Hello, Wormd
1419: Hello, Wormd
1420: Hello, Wormd
1421: Hello, Wormd
1422: Hello, Wormd
1423: Hello, Wormd
1424: Hello, Wormd
1425: Hello, Wormd
1426: Hello, Wormd
1427: Hello, Wormd
1428: Hello, Wormd
1429: Hello, Wormd
1430: Hello, Wormd
1431: Hello, Wormd
1432: Hello, Wormd
1433: Hello, Wormd
1434: Hello, Wormd
1435: Hello, Wormd
fittest string: Hello, World
```

How long it takes will vary since this is based on randomization, but it should almost always finish in under 5000 generations. Woo!


## Now What?

We did it, we have a running simple genetic algorithm. Take some time a play around with the global variables, `POP_SIZE`, `OPTIMAL`, `MUTATION_CHANCE`, `GENERATIONS`. Just make sure to only add characters that are in the lexicon or update the lexicon.

For an example let's try something much longer: `Ray Wenderlich's Swift Algorithm Club Rocks`. Plug that string into `OPTIMAL` and change `GENERATIONS` to `10000`. You'll be able to see that the we are getting somewhere, but you most likely will not reach the optimal string in 10,000 generations. Since we have a larger string let's raise our mutation chance to `200` (1/2 as likely to mutate). You may not get there, but you should get a lot closer than before. With a longer string, too much mutation can make it hard for fit strings to survive. Now try either upping `POP_SIZE` or increase `GENERATIONS`. Either way you should eventually get the value, but there will be a "sweet spot" for an string of a certain size.

Please submit any kind of update to this tutorial or add more examples!
