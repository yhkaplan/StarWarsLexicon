//
//  Starship.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/26.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Starship: SWCategory {
    
    internal var uid: String { return "starship_\(name)" }
    internal var itemName: String { return name }
    
    var name: String
    var model: String
    var starshipClass: String
    var manufacturer: String
    
    //The variables below are treated as strings in the API
    var costInCredits: Double?
    var length: Double?
    var numberOfCrewMembers: Int?
    var numberOfPassengers: Int?
    var maxAtmosphericSpeed: Double? //Is N/A when nil
    var hyperdriveRating: Float? //Consider a double?

    //These are unexciting so I'm leaving them out
//    var maxMegalightsPerHour: Int
//    var cargoCapacity: Int
//    var consumables: String
    
//    films array
//    pilots array
    
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String else {
            print("Parsing error with starship name")
            return nil
        }
        
        guard let model = json["model"] as? String else {
            print("Parsing error with starship model")
            return nil
        }
        
        guard let starshipClass = json["starship_class"] as? String else {
            print("Parsing error with starship class")
            return nil
        }
        
        guard let manufacturer = json["manufacturer"] as? String else {
            print("Parsing error with starship manufacturer")
            return nil
        }
        
        self.name = name
        self.model = model
        self.starshipClass = starshipClass
        self.manufacturer = manufacturer
        
        if let costInCreditsString = json["cost_in_credits"] as? String, let costInCredits = Double(costInCreditsString) {
            self.costInCredits = costInCredits
        } else {
            self.costInCredits = nil
        }
        
        if let lengthString = json["length"] as? String, let length = Double(lengthString) {
            self.length = length
        } else {
            self.length = nil
        }
        
        if let numberOfCrewMembersString = json["crew"] as? String, let numberOfCrewMembers = Int(numberOfCrewMembersString) {
            self.numberOfCrewMembers = numberOfCrewMembers
        } else {
            self.numberOfCrewMembers = nil
        }
        
        if let numberOfPassengersString = json["passengers"] as? String, let numberOfPassengers = Int(numberOfPassengersString) {
            self.numberOfPassengers = numberOfPassengers
        } else {
            self.numberOfPassengers = nil
        }
        
        if let maxAtmosphericSpeedString = json["max_atmosphering_speed"] as? String, let maxAtmosphericSpeed = Double(maxAtmosphericSpeedString) {
            self.maxAtmosphericSpeed = maxAtmosphericSpeed
        } else {
            self.maxAtmosphericSpeed = nil
        }
        
        if let hyperdriveRatingString = json["hyperdrive_rating"] as? String, let hyperdriveRating = Float(hyperdriveRatingString) {
            self.hyperdriveRating = hyperdriveRating
        } else {
            self.hyperdriveRating = nil
        }
    }
}
