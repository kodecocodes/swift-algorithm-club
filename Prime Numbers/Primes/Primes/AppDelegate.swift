//
//  AppDelegate.swift
//  Primes
//
//  Created by Pratikbhai Patel on 6/13/16.
//  Copyright © 2016 Pratikbhai Patel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        performPrimesGeneration()
        return true
    }

    func performPrimesGeneration() {
        
        let primesTo = 1_000_000
        
        let primeGenerator = PrimeGenerator.sharedInstance
        
        var startDate = Date()
        let era_sieve = primeGenerator.eratosthenesPrimes(primesTo)
        var endDate = Date()
        print("Prime generation time for sieve of eratosthenes: \(endDate.timeIntervalSince(startDate) * 1000) ms.")
        
        startDate = Date()
        let at_sieve = primeGenerator.atkinsPrimes(primesTo)
        endDate = Date()
        print("Prime generation time for atkins sieve: \(endDate.timeIntervalSince(startDate) * 1000) ms.")
        print("they are equal \(era_sieve == at_sieve)")
    }
    
}

