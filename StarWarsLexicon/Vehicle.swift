//
//  Vehicle.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/26.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Vehicle: SWCategory {
    internal var uid: String { return "vehicle_\(name)"}
    internal var itemName: String { return name }

    var name: String
    var model: String
    var vehicleClass: String
    var manufacturer: String
    
    var length: Int
    var costInCredits: Int
    var numberOfCrewMembers: Int
    var numberOfPassengers: Int
    var maximumAtmosphericSpeed: Int
    
    //The following parameters are outside the scope of this implementation
    //cargoCapacity
    //cosumables
    
    //films array
    //pilots array
    
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String else {
            print("Parsing error with vehicle name")
            return nil
        }
        
        guard let model = json["model"] as? String else {
            print("Parsing error with vehicle model")
            return nil
        }
        
        guard let vehicleClass = json["vehicle_class"] as? String else {
            print("Parsing error with vehicle class")
            return nil
        }
        
        guard let manufacturer = json["manufacturer"] as? String else {
            print("Parsing error with vehicle manufacturer")
            return nil
        }
        
        guard let lengthString = json["length"] as? String, let length = Int(lengthString) else {
            print("Parsing error with vehicle length")
            return nil
        }
        
        guard let costInCreditsString = json["cost_in_credits"] as? String, let costInCredits = Int(costInCreditsString) else {
            print("Parsing error with vehicle cost in credits")
            return nil
        }
        
        guard let numberOfCrewMembersString = json["crew"] as? String, let numberOfCrewMembers = Int(numberOfCrewMembersString) else {
            print("Parsing error with vehicle number of crew numbers")
            return nil
        }
        
        guard let numberOfPassengersString = json["passengers"] as? String, let numberOfPassengers = Int(numberOfPassengersString) else {
            print("Parsing error with vehicle number of passengers")
            return nil
        }
        
        guard let maximumAtmosphericSpeedString = json["max_atmosphering_speed"] as? String, let maximumAtmosphericSpeed = Int(maximumAtmosphericSpeedString) else {
            print("Parsing error with vehicle maximum atmospheric speed")
            return nil
        }
        
        self.name = name
        self.model = model
        self.vehicleClass = vehicleClass
        self.manufacturer = manufacturer
        self.length = length
        self.costInCredits = costInCredits
        self.numberOfCrewMembers = numberOfCrewMembers
        self.numberOfPassengers = numberOfPassengers
        self.maximumAtmosphericSpeed = maximumAtmosphericSpeed
    }
}
