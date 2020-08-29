# Miller-Rabin Primality Test

In 1976, Gray Miller introduced an algorithm, through his ph.d thesis[1], which determines a primality of the given number. The original algorithm was deterministic under the Extended Reimann Hypothesis, which is yet to be proven. After four years, Michael O. Rabin improved the algorithm[2] by using probabilistic approach and it no longer assumes the unproven hypothesis.

## Probabilistic

The result of the test is simply a boolean. However, `true` does not implicate _the number is prime_. In fact, it means _the number is **probably** prime_. But `false` does mean _the number is composite_.

In order to increase the accuracy of the test, it needs to be iterated few times. If it returns `true` in every single iteration, then we can say with confidence that _the number is pro......bably prime_.

## Algorithm

Let `n` be the given number, and write `n-1` as `2^s·d`, where `d` is odd. And choose a random number `a` within the range from `2` to `n - 1`.

Now make a sequence, in modulo `n`, as following:

> a^d, a^(2·d), a^(4·d), ... , a^((2^(s-1))·d), a^((2^s)·d) = a^(n-1)

And we say the number `n` passes the test, _probably prime_, if 1) `a^d` is congruence to `1` in modulo `n`, or 2) `a^((2^k)·d)` is congruence to `-1` for some `k = 1, 2, ..., s-1`.

### Pseudo Code

The following pseudo code is excerpted from Wikipedia[3]:

![Image of Pseudocode](./Images/img_pseudo.png)

## Usage

```swift
checkWithMillerRabin(7)                      // test if 7 is prime. (default iteration = 1)
checkWithMillerRabin(7, accuracy: 10)       // test if 7 is prime && iterate 10 times.
```

## Reference
1. G. L. Miller, "Riemann's Hypothesis and Tests for Primality". _J. Comput. System Sci._ 13 (1976), 300-317.
2. M. O. Rabin, "Probabilistic algorithm for testing primality". _Journal of Number Theory._ 12 (1980), 128-138.
3. Miller–Rabin primality test - Wikipedia, the free encyclopedia

_Written for Swift Algorithm Club by **Sahn Cha**, @scha00_
_Code updated by **Simon C. Krüger**._

[1]: https://cs.uwaterloo.ca/research/tr/1975/CS-75-27.pdf
[2]: http://www.sciencedirect.com/science/article/pii/0022314X80900840
[3]: https://en.wikipedia.org/wiki/Miller–Rabin_primality_test
