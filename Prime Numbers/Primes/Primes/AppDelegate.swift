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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        performPrimesGeneration()
        return true
    }

    func performPrimesGeneration() {
        
        let primesTo = 1_000_000
        
        let primeGenerator = PrimeGenerator.sharedInstance
        
        var startDate = NSDate().timeIntervalSince1970 * 1000
        let era_sieve = primeGenerator.eratosthenesPrimes(primesTo)
        var endDate = NSDate().timeIntervalSince1970 * 1000
        print("Prime generation time for sieve of eratosthenes: \(endDate - startDate) ms.")
        
        startDate = NSDate().timeIntervalSince1970 * 1000
        let at_sieve = primeGenerator.atkinsPrimes(primesTo)
        endDate = NSDate().timeIntervalSince1970 * 1000
        print("Prime generation time for atkins sieve: \(endDate - startDate) ms.")
        print("they are equal \(era_sieve == at_sieve)")
    }
    
}

