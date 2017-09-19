//
//  CharacterService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/09/17.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct CharacterService: Decodable, SWService {
    //Parameters
    let name: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let url: String
    
    let height: String
    let mass: String
    
    let homeworldURL: String?
    let filmURLs: [String]?
    
    //Enum to help codable convert json to objects
    private enum CodingKeys: String, CodingKey {
        case name
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender
        case url
        case height
        case mass
        case homeworldURL = "homeworld"
        case filmURLs = "films"
    }
}
