//
//  Set.swift
//  MarbleBoom
//
//  Created by Stine Richvoldsen on 1/22/15.
//  Copyright (c) 2015 superrunt. All rights reserved.
//

struct Set<T: Hashable>: SequenceType, Printable { // SequenceType => can be iterated over
    
    // store elements as keys in dictionary, to avoid duplicates
    
    private var dictionary = Dictionary<T, Bool>()
    
    mutating func addElement(newElement: T) {
        dictionary[newElement] = true
    }
    
    mutating func removeElement(element: T) {
        dictionary[element] = nil
    }
    
    func containsElement(element: T) -> Bool {
        return dictionary[element] != nil
    }
    
    func allElements() -> [T] {
        return Array(dictionary.keys)
    }
    
    var count: Int {
        return dictionary.count
    }
    // combine two sets
    func unionSet(otherSet: Set<T>) -> Set<T> {
        var combined = Set<T>()
        
        for obj in dictionary.keys {
            combined.dictionary[obj] = true
        }
        
        for obj in otherSet.dictionary.keys {
            combined.dictionary[obj] = true
        }
        
        return combined
    }
    // required by SequenceType protocol
    func generate() -> IndexingGenerator<Array<T>> {
        return allElements().generate()
    }
    // required by Printable protocol
    var description: String {
        return dictionary.description
    }
}