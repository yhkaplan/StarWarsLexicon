//
//  Character.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/04.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Character: SWCategory {
    
    internal var category: Category { return .character }
    internal var itemName: String { return name }
    
    var name: String
    
    var height: Int?
    var mass: Int?
    
    var hairColor: String
    var skinColor: String
    var eyeColor: String
    var birthYear: String
    var gender: String
    var itemURL: URL
    
    var homeworldURL: URL?
    //"Species" also exists but will not be implemented at this time
    var filmURLArray: [URL?]
    var vehicleURLArray: [URL?]
    var starshipURLArray: [URL?]
    
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String else {
            print("Parsing error with character name")
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
        
        guard let urlString = json["url"] as? String, let url = URL(string: urlString) else {
            print("Parsing error with url")
            return nil
        }
        
        self.name = name
        self.hairColor = hairColor
        self.skinColor = skinColor
        self.eyeColor = eyeColor
        self.birthYear = birthYear
        self.gender = gender
        self.itemURL = url
        
        if let heightString = json["height"] as? String, let height = Int(heightString) {
            self.height = height
        }
        
        if let massString = json["mass"] as? String, let mass = Int(massString) {
            self.mass = mass
        }
        
        if let homeworldString = json["homeworld"] as? String {
            let homeworldURL = URL(string: homeworldString)
            self.homeworldURL = homeworldURL
        }
        
        if let filmStringArray = json["films"] as? [String] {
            let filmURLArray = filmStringArray.map{ URL(string: $0) }
            self.filmURLArray = filmURLArray
        } else {
            self.filmURLArray = []
        }
        
        if let vehicleStringArray = json["vehicles"] as? [String] {
            let vehicleURLArray = vehicleStringArray.map{ URL(string: $0) }
            self.vehicleURLArray = vehicleURLArray
        } else {
            self.vehicleURLArray = []
        }
        
        if let starshipStringArray = json["starships"] as? [String] {
            let starshipURLArray = starshipStringArray.map{ URL(string: $0) }
            self.starshipURLArray = starshipURLArray
        } else {
            self.starshipURLArray = []
        }
    }
}
