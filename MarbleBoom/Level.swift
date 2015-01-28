//
//  Level.swift
//  MarbleBoom
//
//  Created by Stine Richvoldsen on 1/22/15.
//  Copyright (c) 2015 superrunt. All rights reserved.
//

import Foundation

// TODO: tweak for fit (and rows coudl be random?)
let NumColumns = 11
let NumRows = 9

class Level {
    private var targets = Grid2D<Target>(columns: NumColumns, rows: NumRows)
    
    func targetAtColumn(column: Int, row: Int) -> Target? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return targets[column, row]
    }
    
    func shuffle() -> Set<Target> {
        return createInitialTargets()
    }
    
    private func createInitialTargets() -> Set<Target> {
        var set = Set<Target>()
        // 1
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // 2
                var targetType = TargetType.random()
                
                // 3
                let target = Target(column: column, row: row, targetType: targetType)
                targets[column, row] = target
                
                // 4
                set.addElement(target)
            }
        }
        return set
    }
}

