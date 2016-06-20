//
//  ViewController.swift
//  Primes
//
//  Created by Pratikbhai Patel on 6/13/16.
//  Copyright © 2016 Pratikbhai Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var eraSieveTextView: UITextView!
    @IBOutlet weak var atSieveTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performPrimesGeneration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performPrimesGeneration() {
        
        let primesTo = 1_000
        
        let primeGenerator = PrimeGenerator.sharedInstance
        
        var startDate = Date()
        var endDate = Date()
        var era_sieve = [Int]()
        primeGenerator.eratosthenesPrimes(primesTo) { (primesArray) in
            era_sieve = primesArray
            endDate = Date()
            print("Found \(era_sieve.count) primes in : \(endDate.timeIntervalSince(startDate) * 1000) ms.")
            self.eraSieveTextView.text = era_sieve.description
        }
        
        startDate = Date()
        var at_sieve = [Int]()
        primeGenerator.atkinsPrimes(primesTo) { (primesArray) in
            at_sieve = primesArray
            endDate = Date()
            print("Found \(at_sieve.count) primes in : \(endDate.timeIntervalSince(startDate) * 1000) ms.")
            self.atSieveTextView.text = at_sieve.description
        }
    }
}

