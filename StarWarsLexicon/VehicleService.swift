//
//  VehicleService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/09/18.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

//To update and change
struct VehicleService: Decodable, SWService {
    let costInCredits: String
    let hyperDriveRating: String
    let itemName: String
    let url: String
    let length: String
    let manufacturer: String
    let maxAtmosphericSpeed: String
    let model: String
    let name: String
    let numberOfCrewMembers: String
    let numberOfPassengers: String
    let starshipClass: String
    let toFilm: String
}
