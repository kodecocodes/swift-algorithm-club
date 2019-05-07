# Dining Philosophers
The dining philosophers problem Algorithm implemented in Swift (concurrent algorithm design to illustrate synchronization issues and techniques for resolving them using [GCD](https://apple.github.io/swift-corelibs-libdispatch/) and [Semaphore](https://developer.apple.com/reference/dispatch/dispatchsemaphore) in Swift)

Written for Swift Algorithm Club by Jacopo Mangiavacchi


# Introduction

In computer science, the dining philosophers problem is often used in the concurrent algorithm design to illustrate synchronization issues and techniques for resolving them.

It was originally formulated in 1965 by Edsger Dijkstra as a student exam exercise, presented in terms of computers competing for access to tape drive peripherals. Soon after, Tony Hoare gave the problem its present formulation.

This Swift implementation is based on the Chandy/Misra solution, and it uses the GCD Dispatch and Semaphores on the Swift cross platform.

# Problem statement

Five silent philosophers sit at a round table with bowls of spaghetti. Forks are placed between each pair of adjacent philosophers.

Each philosopher must alternately think and eat. A philosopher can only eat spaghetti when they have both left and right forks. Since each fork can be held by only one philosopher, a philosopher can use the fork only if it is not being used by another philosopher. When a philosopher finishes eating, they need to put down both forks so that the forks become available to others. A philosopher can take the fork on their right or the one on their left as they become available, but they cannot start eating before getting both forks.

Eating is not limited by the remaining amounts of spaghetti or stomach space; an infinite supply and an infinite demand are assumed.

The problem is how to design a discipline of behavior (a concurrent algorithm) such that no philosopher will starve; i.e., each can forever continue to alternate between eating and thinking, assuming that no philosopher can know when others may want to eat or think.

This is an illustration of a dining table:

![Dining Philosophers table](https://upload.wikimedia.org/wikipedia/commons/7/7b/An_illustration_of_the_dining_philosophers_problem.png)

# Solution
There are different solutions for this classic algorithm, and this Swift implementation is based on the Chandy/Misra solution. This implementation allows agents to contend for an arbitrary number of resources in a completely distributed scenario with no need for a central authority to control the locking and serialization of resources. 

However, this solution violates the requirement that "the philosophers do not speak to each other" (due to the request messages).

# Description
For every pair of philosophers contending for a resource, create a fork and give it to the philosopher with the lower ID (n for agent Pn). Each fork can either be dirty or clean. Initially, all forks are dirty.
When a philosopher wants to use a set of resources (i.e. eat), said philosopher must obtain the forks from their contending neighbors. The philospher send a message for all such forks needed. When a philosopher with a fork receives a request message, they keep the fork if it is clean, but give it up when it is dirty. If the philosopher sends the fork over, they clean the fork before doing so.
After a philosopher is done eating, all their forks become dirty. If another philosopher had previously requested one of the forks, the philosopher that has just finished eating cleans the fork and sends it.
This solution also allows for a large degree of concurrency, and it will solve an arbitrarily large problem.

In addition, it solves the starvation problem. The clean / dirty labels give a preference to the most "starved" processes and a disadvantage to processes that have just "eaten". One could compare their solution to one where philosophers are not allowed to eat twice in a row without letting others use the forks in between. The Chandy and Misra's solution is more flexible but has an element tending in that direction.

Based on the Chandy and Misra's analysis, a system of preference levels is derived from the distribution of the forks and their clean/dirty states. This system may describe an acyclic graph, and if so, the solution's protocol cannot turn that graph into a cyclic one. This guarantees that deadlock cannot occur. However, if the system is initialized to a perfectly symmetric state, such as all philosophers holding their left side forks, then the graph is cyclic at the outset, and the solution cannot prevent a deadlock. Initializing the system so that philosophers with lower IDs have dirty forks ensures the graph is initially acyclic.


# Swift implementation

This Swift 3.0 implementation of the Chandy/Misra solution is based on the GCD and Semaphore technique that can be built on both macOS and Linux.

The code is based on a ForkPair struct used for holding an array of DispatchSemaphore and a Philosopher struct for associate a couple of forks to each Philosopher.

The ForkPair DispatchSemaphore static array is used for waking the neighbour Philosophers any time a fork pair is put down on the table.

A background DispatchQueue is then used to let any Philosopher run asyncrounosly on the background, and a global DispatchSemaphore is used to keep the main thread on wait forever and let the Philosophers continue forever in their alternate think and eat cycle.
  
# See also

Dining Philosophers on Wikipedia https://en.wikipedia.org/wiki/Dining_philosophers_problem

Written for Swift Algorithm Club by Jacopo Mangiavacchi
Swift 4.2 check by Bruno Scheele
