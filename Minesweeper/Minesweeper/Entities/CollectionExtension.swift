//
//  CollectionExtension.swift
//  Minesweeper
//
//  Created by Dorian Grolaux on 21/02/2018.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
