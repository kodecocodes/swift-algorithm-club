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
        self.performPrimesGeneration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performPrimesGeneration() {
        
        let eraMax = 1_000_000  // max integer for Eratosthenes primes
        let atMax = 1_000       // max integer for Atkins prime
        
        let primeGenerator = PrimeGenerator.sharedInstance
        
        let eraStartDate = Date()
        var era_sieve = [Int]()
        primeGenerator.eratosthenesPrimes(eraMax) { (primesArray) in
            era_sieve = primesArray
            let eraEndDate = Date()
            print("Found \(era_sieve.count) primes in : \(eraEndDate.timeIntervalSince(eraStartDate) * 1000) ms.")
            DispatchQueue.main.async(execute: {
                self.eraSieveTextView.text = era_sieve.description
            })
        }
        
        let atStartDate = Date()
        var at_sieve = [Int]()
        primeGenerator.atkinsPrimes(atMax) { (primesArray) in
            at_sieve = primesArray
            let atEndDate = Date()
            print("Found \(at_sieve.count) primes in : \(atEndDate.timeIntervalSince(atStartDate) * 1000) ms.")
            DispatchQueue.main.async(execute: {
                self.atSieveTextView.text = at_sieve.description
            })
        }
    }
}

