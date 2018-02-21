//
//  Cell.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 19/02/2018.
//

import Foundation

struct Cell {
    
    var state: CellState = .hidden
    
    let containsBomb: Bool
    var neighbouringBombs: Int?
    
    init(containsBomb: Bool) {
        self.containsBomb = containsBomb
        self.neighbouringBombs = containsBomb ? nil : 0
    }
    
    init() {
        self.containsBomb = false
        self.neighbouringBombs = 0
    }
}
