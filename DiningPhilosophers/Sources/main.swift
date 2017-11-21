//
//  Swift Dining philosophers problem Algorithm
//  https://en.wikipedia.org/wiki/Dining_philosophers_problem
//
//  Created by Jacopo Mangiavacchi on 11/02/16.
//
//

// last checked with Xcode 9.0b4
#if swift(>=4.0)
  print("Hello, Swift 4!")
#endif

import Dispatch

let numberOfPhilosophers = 4

struct ForkPair {
    static let forksSemaphore: [DispatchSemaphore] = Array(repeating: DispatchSemaphore(value: 1), count: numberOfPhilosophers)

    let leftFork: DispatchSemaphore
    let rightFork: DispatchSemaphore

    init(leftIndex: Int, rightIndex: Int) {
        //Order forks by index to prevent deadlock
        if leftIndex > rightIndex {
            leftFork = ForkPair.forksSemaphore[leftIndex]
            rightFork = ForkPair.forksSemaphore[rightIndex]
        } else {
            leftFork = ForkPair.forksSemaphore[rightIndex]
            rightFork = ForkPair.forksSemaphore[leftIndex]
        }
    }

    func pickUp() {
        //Acquire by starting with the lower index
        leftFork.wait()
        rightFork.wait()
    }

    func putDown() {
        //The order does not matter here
        leftFork.signal()
        rightFork.signal()
    }
}

struct Philosophers {
    let forkPair: ForkPair
    let philosopherIndex: Int

    var leftIndex = -1
    var rightIndex = -1

    init(philosopherIndex: Int) {
        leftIndex = philosopherIndex
        rightIndex = philosopherIndex - 1

        if rightIndex < 0 {
            rightIndex += numberOfPhilosophers
        }

        self.forkPair = ForkPair(leftIndex: leftIndex, rightIndex: rightIndex)
        self.philosopherIndex = philosopherIndex

        print("Philosopher: \(philosopherIndex)  left: \(leftIndex)  right: \(rightIndex)")
    }

    func run() {
        while true {
            print("Acquiring lock for Philosopher: \(philosopherIndex) Left:\(leftIndex) Right:\(rightIndex)")
            forkPair.pickUp()
            print("Start Eating Philosopher: \(philosopherIndex)")
            //sleep(1000)
            print("Releasing lock for Philosopher: \(philosopherIndex) Left:\(leftIndex) Right:\(rightIndex)")
            forkPair.putDown()
        }
    }
}

// Layout of the table (P = philosopher, f = fork) for 4 Philosophers
//          P0
//       f3    f0
//     P3        P1
//       f2    f1
//          P2
let globalSem = DispatchSemaphore(value: 0)

for i in 0..<numberOfPhilosophers {
    if #available(macOS 10.10, *) {
        DispatchQueue.global(qos: .background).async {
            let p = Philosophers(philosopherIndex: i)

            p.run()
        }
    }
}

//Start the thread signaling the semaphore
for semaphore in ForkPair.forksSemaphore {
    semaphore.signal()
}

//Wait forever
globalSem.wait()
