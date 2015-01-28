//
//  Target.swift
//  MarbleBoom
//
//  Created by Stine Richvoldsen on 1/21/15.
//  Copyright (c) 2015 superrunt. All rights reserved.
//

import SpriteKit

class Target: Printable, Hashable {
    var column: Int
    var row: Int
    let targetType: TargetType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, targetType: TargetType) {
        self.column = column
        self.row = row
        self.targetType = targetType
    }
    // conform to Printable protocol
    var description: String {
        return "type:\(targetType) square:(\(column),\(row))"
    }
    // conform to Hashable protocol
    var hashValue: Int {
        return row*10 + column
    }
}

// conform to Hashable protocol
func ==(lhs: Target, rhs: Target) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}

enum TargetType: Int, Printable {
    case Unknown = 0, Croissant, Cupcake, Danish, Donut, Macaroon, SugarCookie
    
    var spriteName: String {
        let spriteNames = [
            "Croissant",
            "Cupcake",
            "Danish",
            "Donut",
            "Macaroon",
            "SugarCookie"]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    var description: String {
        return spriteName
    }
    
    static func random() -> TargetType {
        return TargetType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}