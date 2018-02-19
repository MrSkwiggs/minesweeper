//
//  Cell.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 19/02/2018.
//

import Foundation

class Cell {
    var revealed: Bool = false
    var flagged: Bool = false
    
    let containsBomb: Bool!
    let neighbouringBombs: Int?
    
    init(containsBomb: Bool) {
        self.containsBomb = containsBomb
        self.neighbouringBombs = containsBomb ? nil : 0
    }
    
    init() {
        self.containsBomb = false
        self.neighbouringBombs = 0
    }
}
