//
//  Character.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/04.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Character: SWCategory {
    
    internal var uid: String { return "character" + "\(name)" }
    
    var name: String
    
    var height: Int
    var mass: Int
    
    var hairColor: String
    var skinColor: String
    var eyeColor: String
    var birthYear: String
    var gender: String
    
    //homeworld, films, species, vehicles, starships, created, edited, url
}
