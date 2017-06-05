//
//  SWObjectStore.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/07.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

/*
 This class is exclusively for storing groups of Star Wars objects
defined in their respective structs (Film, Planet, etc). All interaction
with the API will be in the DataService struct
*/
//Implement Core Data here?
struct SWObjectStore {
    //A dictionary that stores an array of all items
    private var allSWObjects = Dictionary<String, [Any]> ()//Can a swift dictionary hold two diff value types??
    
    mutating func addJSONObject<T: SWCategory>(swCategory: T, category: String) -> Void {
        allSWObjects[category] = swCategory as? [Any]
    }
    
    func provideObjects<T: SWCategory>(swCategory: String) -> [T]? {
        guard allSWObjects[swCategory] == nil else {
            return nil
        }
        return allSWObjects[swCategory] as? [T]
    }
    
}
