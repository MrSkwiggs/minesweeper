//
//  CellState.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 20/02/2018.
//

import Foundation

enum CellState {
    
    /// The cell content is hidden to the player
    case hidden
    
    /// The cell content is visible to the player
    case revealed
    
    /// The player marked this cell as possible bomb
    case flagged
    
    /// The bomb was triggered
    case exploded
}
