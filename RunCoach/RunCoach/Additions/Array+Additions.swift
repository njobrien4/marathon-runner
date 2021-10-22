//
//  Array+Additions.swift
//  RunCoach
//
//  Created by Nicole O'Brien on 10/20/21.
//

extension Array {
    
    subscript(safeIndex index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
    
}
