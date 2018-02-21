//
//  MineField.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 19/02/2018.
//

import Foundation

typealias Coordinates = (x: Int, y: Int)

class MineField {
    private let cells: [[Cell]]!
    
    init(cells: [[Cell]]) {
        self.cells = cells
    }
    
    
    init(gridSize size: Int, withBombAmount bombs: Int) {
        
        let randomPlacements = MineField.getPlacementOptions(count: bombs, forArraySize: size)
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
    
    private static func markPlacedBombs(inField field: inout [[Cell]], placedBombs: [Coordinates]) {
        for placedBomb in placedBombs {
            let immediateNeighboursCoords = MineField.getImmediateNeighbours(ofCellAt: placedBomb, inField: field)
            for neighbourCoords in immediateNeighboursCoords {
                
                // we can force unwrap here, cells without a bomb
                field[neighbourCoords.x][neighbourCoords.y].neighbouringBombs! += 1
            }
        }
    }
    
    private static func getPlacementOptions(forArraySize size: Int) -> [Coordinates] {
        var options = [Coordinates]()
        for x in 0..<size {
            for y in 0..<size {
                options.append((x: x, y: y))
            }
        }
        
        return options
    }
    
    
    private static func getPlacementOptions(count: Int, forArraySize size: Int) -> [Coordinates] {
        var allPlacementsArray = getPlacementOptions(forArraySize: size)
        var limitedPlacementsArray = [Coordinates]()
        
        for _ in 0..<count {
            let randIndex = Random.int(min: 0, max: allPlacementsArray.count - 1)
            
            limitedPlacementsArray.append(allPlacementsArray.remove(at: randIndex))
        }
        
        return limitedPlacementsArray
    }
}

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
