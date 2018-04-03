//
//  MineField.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 19/02/2018.
//

import Foundation

typealias Coordinates = (x: Int, y: Int)

class MineField {
    private let cells: [[Cell]]
    
    /**
     Initialise the Minefield with an already filled field (use for saved games for instance).
     - parameter cells: The cell 2d array.
     **/
    init(cells: [[Cell]]) {
        self.cells = cells
    }
    
    
    /**
     Initialise the Minefield of given square size and randomly placing the given amount of bombs.
     - parameter size: The length of each side of the field measured in amount of cells. (Total number of cells is amount squared).
     - parameter bombs: The amount of bombs to randomly place around in the Minefield.
     **/
    init(squareSideLength size: Int, withBombAmount bombs: Int) {
        
        let randomPlacements = MineField.getRandomMinesPlacements(mineAmount: bombs, forMinefieldTotalCellAmount: size * size)
        var cells = [[Cell]]()
        
        for x in 0..<size {
            var yCells = [Cell]()
            
            for y in 0..<size {
                yCells.append(Cell(containsBomb: randomPlacements.contains(where: { placement -> Bool in
                    return placement == (x: x, y: y)
                })))
            }
            cells.append(yCells)
        }
        
        MineField.markPlacedBombs(inField: &cells, placedBombs: randomPlacements)
        
        self.cells = cells
    }
    
    
    /**
     Retrieve a cell's immediate neighbours (up, down, left, right & diagonally).
     - parameter cellCoords: The X & Y position of the cell to retrieve neighbours from.
     - parameter field: The Minefield to look through.
     - parameter returns: All the coordinates of the given cell's neighbours (up to 8).
     **/
    private static func getImmediateNeighbours(ofCellAt cellCoords: Coordinates, inField field: [[Cell]]) -> [Coordinates] {
        var neighbouringCellsCoords = [Coordinates]()
        
        for xDelta in -1...1 {
            if let _ = field[safe: xDelta + cellCoords.x] {
                let x = xDelta + cellCoords.x
                
                for yDelta in -1...1 {
                    if let cell = field[x][safe: yDelta + cellCoords.y], !cell.containsBomb {
                        neighbouringCellsCoords.append((x: x, y: yDelta + cellCoords.y))
                    }
                }
            }
        }
        
        return neighbouringCellsCoords
    }
    
    
    /**
     For any given bomb, increment all neighbour's adjacent bombs count. Only increments cells that do not already contain a bomb.
     - parameter field: The Minefield's cells to mark.
     - parameter placedBombs: The coordinates of all the bombs to mark.
     **/
    private static func markPlacedBombs(inField field: inout [[Cell]], placedBombs: [Coordinates]) {
        for placedBomb in placedBombs {
            let immediateNeighboursCoords = MineField.getImmediateNeighbours(ofCellAt: placedBomb, inField: field)
            for neighbourCoords in immediateNeighboursCoords {
                
                // we can force unwrap here, cells without a bomb
                field[neighbourCoords.x][neighbourCoords.y].neighbouringBombs! += 1
            }
        }
    }
    
    
    /**
     Retrieves all coordinates pairs for a given Minefield size.
     - parameter size: The size of the Minefield.
     - returns: An Array containing all the coordinates in that Minefield.
     **/
    private static func getPlacementOptions(foMinefieldTotalCellAmount size: Int) -> [Coordinates] {
        var options = [Coordinates]()
        for x in 0..<size {
            for y in 0..<size {
                options.append((x: x, y: y))
            }
        }
        
        return options
    }
    
    
    /**
     Returns a given number of random, unique correct coordinates for a Minefield's given size.
     - parameter count: The amount of random coordinates to get. If higher than actual amount of possible coordinates in the given Minefield's size, will be set to maximum amount of possible coordinates.
     - parameter size: The size of the Minefield.
     - returns: An Array containing the requested amount of randomized unique coordinates.
     **/
    private static func getRandomMinesPlacements(mineAmount: Int, forMinefieldTotalCellAmount minefieldCellAmount: Int) -> [Coordinates] {
        // High limit on the number of mines to place
        let finalAmount = mineAmount > minefieldCellAmount ? minefieldCellAmount : mineAmount
        
        var allPlacementsArray = getPlacementOptions(foMinefieldTotalCellAmount: minefieldCellAmount)
        var limitedPlacementsArray = [Coordinates]()
        
        for _ in 0..<finalAmount {
            let randIndex = Random.int(min: 0, max: allPlacementsArray.count - 1)
            
            limitedPlacementsArray.append(allPlacementsArray.remove(at: randIndex))
        }
        
        return limitedPlacementsArray
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
    subscript(x: Int, y: Int) -> Cell? {
        guard let firstRow = cells.first, firstRow.first != nil else { return nil }

        let totalRows = cells.count
        let totalColumns = firstRow.count

        guard x < totalColumns && y < totalRows else { return nil }
        return cells[y][x]
    }
}
