//
//  MinePlacementInteractor.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 03/04/2018.
//

import Foundation

struct MinePlacementInteractor {

    /**
     Generates a Minefield's Cell array of given dimensions and randomly places the given amount of mines.
     - parameter mineAmount: The amount of mines to randomly place around in the Minefield's Cell array.
     - parameter dimensions: The height & width of the field measured in amount of cells.
     */
    static func generateCellArray(withMineAmount mineAmount: Int, inCellArrayWithDimensions dimensions: Dimensions) -> [[Cell]] {

        let randomPlacements = getRandomMinePlacements(mineAmount: mineAmount, inCellArrayWithDimensions: dimensions)
        var cells = [[Cell]]()

        for x in 0..<dimensions.height {
            var yCells = [Cell]()

            for y in 0..<dimensions.width {
                yCells.append(Cell(containsBomb: randomPlacements.contains(where: { placement -> Bool in
                    return placement == (x: x, y: y)
                })))
            }
            cells.append(yCells)
        }

        markPlacedMines(atCoordinates: randomPlacements, inCellArray: &cells)

        return cells
    }

    /**
     Retrieve a cell's immediate neighbours (up, down, left, right & diagonally).
     - parameter cellCoords: The X & Y position of the cell to retrieve neighbours from.
     - parameter field: The Minefield to look through.
     - parameter returns: All the coordinates of the given cell's neighbours (up to 8).
     */
    private static func getImmediateNeighbours(ofCellAt cellCoords: Coordinates, inCellArray cellArray: [[Cell]]) -> [Coordinates] {
        var neighbouringCellsCoords = [Coordinates]()

        for xDelta in -1...1 {
            if let _ = cellArray[safe: xDelta + cellCoords.x] {
                let x = xDelta + cellCoords.x

                for yDelta in -1...1 {
                    if let cell = cellArray[x][safe: yDelta + cellCoords.y], !cell.containsBomb {
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
     */
    private static func markPlacedMines(atCoordinates placedMinesCoordinates: [Coordinates], inCellArray cellArray: inout [[Cell]]) {
        for placedMineCoordinates in placedMinesCoordinates {
            let immediateNeighboursCoords = getImmediateNeighbours(ofCellAt: placedMineCoordinates, inCellArray: cellArray)
            for neighbourCoords in immediateNeighboursCoords {

                // we can force unwrap here, cells without a bomb
                cellArray[neighbourCoords.x][neighbourCoords.y].neighbouringBombs! += 1
            }
        }
    }

    /**
     Retrieves all coordinates pairs for a given Minefield size.
     - parameter size: The size of the Minefield.
     - returns: An Array containing all the coordinates in that Minefield.
     */
    private static func getAllPossibleMinePlacements(inCellArrayWithDimensions dimensions: Dimensions) -> [Coordinates] {
        var options = [Coordinates]()
        for x in 0..<dimensions.height {
            for y in 0..<dimensions.width {
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
     */
    private static func getRandomMinePlacements(mineAmount: Int, inCellArrayWithDimensions dimensions: Dimensions) -> [Coordinates] {
        // High limit on the number of mines to place
        let finalAmount = mineAmount > dimensions.height * dimensions.width ? dimensions.height * dimensions.width : mineAmount

        var allPlacementsArray = getAllPossibleMinePlacements(inCellArrayWithDimensions: dimensions)
        var limitedPlacementsArray = [Coordinates]()

        for _ in 0..<finalAmount {
            let randIndex = Random.int(min: 0, max: allPlacementsArray.count - 1)

            limitedPlacementsArray.append(allPlacementsArray.remove(at: randIndex))
        }

        return limitedPlacementsArray
    }
}
