//
//  Grid2D.swift
//  MarbleBoom
//
//  Created by Stine Richvoldsen on 1/22/15.
//  Copyright (c) 2015 superrunt. All rights reserved.
//

struct Grid2D<T> { // generic struct
    let columns: Int
    let rows: Int
    private var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count: rows*columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}
