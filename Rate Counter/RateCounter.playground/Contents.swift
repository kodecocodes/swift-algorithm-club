//: Playground - noun: a place where people can play

// Simple Version
let rateCounter = RateCounter()

for i in 0..<300 {
    rateCounter.hit(i)
}

rateCounter.getCount(299) // return 300
rateCounter.getCount(1) // return 2
rateCounter.getCount(-1) // return 0


// Cleanup Version
let rateCounterWithClean = RateCounterWithClean()

for i in 0..<300 {
    rateCounterWithClean.hit(i)
}

rateCounterWithClean.getCount(299) // return 300

for i in 300..<600 {
    rateCounterWithClean.hit(i)
}

rateCounterWithClean.getCount(599) // return 300

rateCounterWithClean.getCount(299) // should return 0, we clean all keys < 299 when we call getCount(599)


// Array Version
let rateCounterByArray = RateCounterByArray()
for i in 0..<300 {
    rateCounterByArray.hit(i)
}

rateCounterByArray.getCount(299) // return 300

for i in 300..<600 {
    rateCounterByArray.hit(i)
}

rateCounterByArray.getCount(599) // return 300

rateCounterByArray.getCount(299) // return 0
