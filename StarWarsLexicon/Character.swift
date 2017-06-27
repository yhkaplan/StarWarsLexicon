//
//  Character.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/04.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Character: SWCategory {
    
    internal var uid: String { return "character_\(name)" }
    internal var itemName: String { return name }
    
    var name: String
    
    var height: String
    var mass: String
    
    var hairColor: String
    var skinColor: String
    var eyeColor: String
    var birthYear: String
    var gender: String
    
    //homeworld, films, species, vehicles, starships
    
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String else {
            print("Parsing error with character name")
            return nil
        }
        
        guard let height = json["height"] as? String else {
            print("Parsing error with character height")
            return nil
        }
        
        
        guard let mass = json["mass"] as? String else {
            print("Parsing error with character mass")
            return nil
        }
        
        guard let hairColor = json["hair_color"] as? String else {
            print("Parsing error with character hair color")
            return nil
        }
        
        guard let skinColor = json["skin_color"] as? String else {
            print("Parsing error with character skin color")
            return nil
        }
        
        guard let eyeColor = json["eye_color"] as? String else {
            print("Parsing error with character eye color")
            return nil
        }
        
        guard let birthYear = json["birth_year"] as? String else {
            print("Parsing error with character birth year")
            return nil
        }
        
        guard let gender = json["gender"] as? String else {
            print("Parsing error with character gender")
            return nil
        }
        
        self.name = name
        self.height = height
        self.mass = mass
        self.hairColor = hairColor
        self.skinColor = skinColor
        self.eyeColor = eyeColor
        self.birthYear = birthYear
        self.gender = gender
    }
}
