//
//  MainMenuViewController.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 07/04/2018.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBAction func play(_ sender: Any) {
        let grid = MineField(dimensions: Dimensions(width: 30, height: 20), withMineAmount: 99)
        print(grid)
    }

}
