//
//  Random.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 19/02/2018.
//

import Foundation

class Random {
    
    /// Returns a random Float
    static func float() -> Float {
        return Float(arc4random() / 0xFFFFFFFF)
    }
    
    /// Returns a random Float between a minima and maxima
    static func float(min: Float, max: Float) -> Float {
        return self.float() * (max - min) + min
    }
    
    /// Returns a random Int (BOGUS - don't use)
    static func int() -> Int {
        return Int(self.float())
    }
    
    /// Returns a random Int between a minima and maxima
    static func int(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max) - UInt32(min) + 1))
    }
}
