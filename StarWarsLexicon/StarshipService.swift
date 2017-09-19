//
//  StarshipService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/09/18.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct StarshipService: Decodable, SWService {
    let costInCredits: String
    let hyperDriveRating: String
    let url: String
    let length: String
    let manufacturer: String
    let maxAtmosphericSpeed: String
    let model: String
    let name: String
    let numberOfCrewMembers: String
    let numberOfPassengers: String
    let starshipClass: String
    let toFilm: [String]
    
    //Enum to help codable convert json to objects
    private enum CodingKeys: String, CodingKey {
        case costInCredits = "cost_in_credits"
        case hyperDriveRating = "hyperdrive_rating"
        case url
        case length
        case manufacturer
        case maxAtmosphericSpeed = "max_atmosphering_speed"
        case model
        case name
        case numberOfCrewMembers = "crew"
        case numberOfPassengers = "passengers"
        case starshipClass = "starship_class"
        case toFilm = "films"
    }
}
