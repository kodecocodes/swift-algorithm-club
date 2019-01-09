//: Playground - noun: a place where people can play

do {
    // Real primes
    try checkWithMillerRabin(5)
    try checkWithMillerRabin(439)
    try checkWithMillerRabin(1201)
    try checkWithMillerRabin(143477)
    try checkWithMillerRabin(1299869)
    try checkWithMillerRabin(15487361)
    try checkWithMillerRabin(179426363)
    
    // Fake primes
    try checkWithMillerRabin(15)
    try checkWithMillerRabin(435)
    try checkWithMillerRabin(1207)
    try checkWithMillerRabin(143473)
    try checkWithMillerRabin(1291869)
    try checkWithMillerRabin(15487161)
    try checkWithMillerRabin(178426363)
    
    // Specifying accuracy
    try checkWithMillerRabin(179426363, accuracy: 10)
} catch {
    dump(error)
}