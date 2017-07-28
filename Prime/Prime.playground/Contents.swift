//: Playground - noun: a place where people can play

let prime = SlowPrime()
let ret = prime.findPrimes(100)
// [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]


let fastPrime = FastPrime()
let fastRet = fastPrime.findPrimes(100)