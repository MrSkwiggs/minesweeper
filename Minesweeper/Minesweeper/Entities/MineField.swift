//
//  MineField.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 19/02/2018.
//

import Foundation

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
                
                cells.append(yCells)
            }
        }
        
        self.cells = cells
    }
    
    
    private static func getPlacementOptions(forArraySize size: Int) -> [(x: Int, y: Int)] {
        var options = [(x: Int, y: Int)]()
        for x in 0..<size {
            for y in 0..<size {
                options.append((x: x, y: y))
            }
        }
        
        return options
    }
    
    
    private static func getPlacementOptions(count: Int, forArraySize size: Int) -> [(x: Int, y: Int)] {
        var allPlacementsArray = getPlacementOptions(forArraySize: size)
        var limitedPlacementsArray = [(x: Int, y: Int)]()
        
        for _ in 0..<count {
            let randIndex = Random.int(min: 0, max: allPlacementsArray.count)
            
            limitedPlacementsArray.append(allPlacementsArray.remove(at: randIndex))
        }
        
        return limitedPlacementsArray
    }
}
