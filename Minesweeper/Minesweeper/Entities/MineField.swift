//
//  MineField.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 19/02/2018.
//

import Foundation

typealias Coordinates = (x: Int, y: Int)
typealias Dimensions = (height: Int, width: Int)

class MineField {
    private let cells: [[Cell]]
    private var dimensions: Dimensions {
        get {
            return (height: cells.count, width: cells[0].count)
        }
    }
    
    /**
     Initialise the Minefield with an already filled field (use for saved games for instance).
     - parameter cells: The cell 2d array.
     **/
    init(cells: [[Cell]]) {
        guard cells.count != 0 && cells[0].count != 0 else {
            fatalError()
        }
        self.cells = cells
    }


    init(dimensions: Dimensions, withMineAmount mineAmount: Int) {
        guard dimensions.height > 0 && dimensions.width > 0 else {
            fatalError()
        }

        self.cells = MinePlacementInteractor.generateCellArray(withMineAmount: mineAmount, inCellArrayWithDimensions: dimensions)
    }
}


/**
 Extension for nicely printing a Minefield and its contents.
 Use by calling print(minefield).
 **/
extension MineField: CustomDebugStringConvertible {
    var debugDescription: String {
        var string = ""
        for xCellArray in self.cells {
            for cell in xCellArray {
                if cell.containsBomb {
                    string += " X  "
                } else {
                    string += " \(cell.neighbouringBombs!)  "
                }
            }
            string += "\n\n"
        }
        
        return string
    }
}

extension MineField {
    /**
     Easy access to the MineField's cell by referencing a 2d coordinate.
    */
    subscript(x: Int, y: Int) -> Cell {
        guard let firstRow = cells.first, firstRow.first != nil else { fatalError() }

        let totalRows = cells.count
        let totalColumns = firstRow.count

        guard x < totalColumns && y < totalRows else { fatalError() }
        return cells[y][x]
    }
}
