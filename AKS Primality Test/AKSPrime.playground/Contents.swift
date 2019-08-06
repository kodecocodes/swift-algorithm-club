import UIKit

func polynomialCoeffs(n: Int) -> [Int] {
//    var result: [Int] = [Int](count : n+1, repeatedValue : 0)
    var result = [Int](repeating: 0, count: n+1)
    
    result[0]=1
    for i in 1 ..< n/2+1 { //Progress up, until reaching the middle value
        result[i] = result[i-1] * (n-i+1)/i;
    }
    for i in n/2+1 ..< n+1 { //Copy the inverse of the first part
        result[i] = result[n-i];
    }
    // Take into account the sign
    for i in stride(from: 1, through: n, by: 2) {
        result[i] = -result[i]
    }
    
    return result
}

func isPrime(n: Int) -> Bool {
    
    var coeffs = polynomialCoeffs(n: n)
    
    coeffs[0] -= 1
    coeffs[n] += 1
    
    for i in 1 ... n {
        if coeffs[i]%n != 0 {
            return false
        }
    }
    
    return true
}

for i in 0...10 {
    
    let coeffs = polynomialCoeffs(n: i)
    
    print("(x-1)^\(i) = ")
    if i == 0 {
        print("1")
    } else {
        if i == 1 {
            print("x")
        } else {
            print("x^\(i)")
            if i == 2 {
                print("\(coeffs[i-1])x")
            } else {
                for j in 1...(i - 2) {
                    if j%2 == 0 {
                        print("+\(coeffs[j])x^\(i-j)")
                    } else {
                        print("\(coeffs[j])x^\(i-j)")
                    }
                }
                if (i-1)%2 == 0 {
                    print("+\(coeffs[i-1])x")
                } else {
                    print("\(coeffs[i-1])x")
                }
            }
        }
        if i%2 == 0 {
            print("+\(coeffs[i])")
        } else {
            print("\(coeffs[i])")
        }
    }
    print()
}

print()
print("Primes under 50 : ")

for i in 1...50 {
    if isPrime(n: i) {
        print("\(i) ")
    }
}
