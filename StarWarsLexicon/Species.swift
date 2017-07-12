//
//  Species.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/26.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Species: SWCategory {
    
    internal var category: Category { return .species }
    internal var itemName: String { return name }
    
    var name: String
    var classification: String
    var designation: String
    var language: String
    var itemURL: URL
    //Comma separated strings
    var eyeColors: String
    var hairColors: String
    var skinColors: String
    
    var averageHeight: Int
    var averageLifespan: Int
    
//    var homeworld: URL //Only URL for URL object
//    var characters: [Character]
//    var films: [Film]
    
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String else {
            print("Parsing error with species name")
            return nil
        }
        
        guard let classification = json["classification"] as? String else {
            print("Parsing error with species classification")
            return nil
        }
        
        guard let designation = json["designation"] as? String else {
            print("Parsing error with species designation")
            return nil
        }
        
        guard let language = json["language"] as? String else {
            print("Parsing error with species designation")
            return nil
        }
        
        guard let urlString = json["url"] as? String, let url = URL(string: urlString) else {
            print("Parsing error with species url")
            return nil
        }
        
        guard let eyeColors = json["eye_colors"] as? String else {
            print("Parsing error with species eye colors")
            return nil
        }
        
        guard let hairColors = json["hair_colors"] as? String else {
            print("Parsing error with species hair colors")
            return nil
        }
        
        guard let skinColors = json["skin_colors"] as? String else {
            print("Parsing error with species skin colors")
            return nil
        }
        
        guard let averageHeightString = json["average_height"] as? String, let averageHeight = Int(averageHeightString) else {
            print("Parsing error with species average height")
            return nil
        }
        
        guard let averageLifespanString = json["average_lifespan"] as? String, let averageLifespan = Int(averageLifespanString) else {
            print("Parsing error with species average lifespan")
            return nil
        }
        
        self.name = name
        self.classification = classification
        self.designation = designation
        self.language = language
        self.itemURL = url
        self.eyeColors = eyeColors
        self.hairColors = hairColors
        self.skinColors = skinColors
        self.averageHeight = averageHeight
        self.averageLifespan = averageLifespan
    }
}
