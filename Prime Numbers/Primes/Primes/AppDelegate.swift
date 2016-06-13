//
//  AppDelegate.swift
//  Primes
//
//  Created by Pratikbhai Patel on 6/13/16.
//  Copyright © 2016 Pratikbhai Patel. All rights reserved.
//

import UIKit

infix operator ^^ { associativity left precedence 160 }
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(CGFloat(radix), CGFloat(power)))
}

infix operator .. {associativity left precedence 60 }

func ..<T: Strideable>(left: T, right: T.Stride) -> (T, T.Stride) {
    return (left, right)
}

func ..<T: Strideable>(left: (T, T.Stride), right: T) -> [T] {
    return [T](left.0.stride(through: right, by: left.1))
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        performPrimesGeneration()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func performPrimesGeneration() {
        
        let primesTo = 1_000_000
        
        func eratosthenes_sieve(max: Int) -> [Int] {
            assert(max > 1, "Prime numbers can only be above 1")
            print("Getting all primes under \(max)")
            let m = Int(sqrt(ceil(Double(max))))
            let set = NSMutableSet(array: 3..2..max)
            set.addObject(2)
            for i in (2..1..m) {
                if (set.containsObject(i)) {
                    for j in i^^2..i..max {
                        set.removeObject(j)
                    }
                }
            }
            return set.sortedArrayUsingDescriptors([NSSortDescriptor(key: "integerValue", ascending: true)]) as! [Int]
        }
        
        var startDate = NSDate().timeIntervalSince1970 * 1000
        //        print(eratosthenes_sieve(5000))
        let era_sieve = eratosthenes_sieve(primesTo)
        var endDate = NSDate().timeIntervalSince1970 * 1000
        print("Prime generation time for sieve of eratosthenes: \(endDate - startDate) ms.")
        
        func atkins_sieve(max: Int) -> [Int] {
            var is_prime = [Bool](count: max + 1, repeatedValue: false)
            is_prime[2] = true
            is_prime[3] = true
            let limit = Int(ceil(sqrt(Double(max))))
            for x in 1...limit {
                for y in 1...limit {
                    var num = 4 * x * x + y * y
                    if (num <= max && (num % 12 == 1 || num % 12 == 5)) {
                        is_prime[num] = true
                    }
                    num = 3 * x * x + y * y
                    if (num <= max && num % 12 == 7) {
                        is_prime[num] = true
                    }
                    if (x > y) {
                        num = 3 * x * x - y * y
                        if (num <= max && num % 12 == 11) {
                            is_prime[num] = true
                        }
                    }
                }
            }
            if limit > 5 {
                for i in 5...limit {
                    if is_prime[i] {
                        for j in (i * i)..i..max {
                            is_prime[j] = false
                        }
                    }
                }
            }
            var primesArray = [Int]()
            for (idx, val) in is_prime.enumerate() {
                if val == true { primesArray.append(idx) }
            }
            return primesArray
        }
        
        startDate = NSDate().timeIntervalSince1970 * 1000
        //        print(atkins_sieve(5000))
        let at_sieve = atkins_sieve(primesTo)
        endDate = NSDate().timeIntervalSince1970 * 1000
        print("Prime generation time for atkins sieve: \(endDate - startDate) ms.")
        print("they are equal \(era_sieve == at_sieve)")
    }
    

}

