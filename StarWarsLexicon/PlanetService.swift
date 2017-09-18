//
//  PlanetService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/09/18.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct PlanetService: Decodable, SWService {
    let climate: String
    let diameter: String
    let gravity: String
    let url: String
    let name: String
    let orbitalPeriod: String
    let population: String
    let rotationPeriod: String
    let surfaceWater: String
    let terrain: String
    let toFilm: String
    
    //Enum to help codable convert json to objects
//    private enum CodingKeys: String, CodingKey {
//
//    }
}
