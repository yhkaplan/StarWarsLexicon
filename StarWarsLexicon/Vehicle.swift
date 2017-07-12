//
//  Vehicle.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/26.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Vehicle: SWCategory {
    
    internal var category: Category { return .vehicle }
    internal var itemName: String { return name }

    var name: String
    var model: String
    var vehicleClass: String
    var manufacturer: String
    var itemURL: URL
    
    //The variables below are treated as strings in the API
    var costInCredits: Double?
    var length: Double?
    var numberOfCrewMembers: Int?
    var numberOfPassengers: Int?
    var maximumAtmosphericSpeed: Double?
    
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
        
        guard let urlString = json["url"] as? String, let url = URL(string: urlString) else {
            print("Parsing error with vehicle url")
            return nil
        }
        
        self.name = name
        self.model = model
        self.vehicleClass = vehicleClass
        self.manufacturer = manufacturer
        self.itemURL = url
        
        if let costInCreditsString = json["cost_in_credits"] as? String, let costInCredits = Double(costInCreditsString) {
            self.costInCredits = costInCredits
        }
        
        if let lengthString = json["length"] as? String, let length = Double(lengthString) {
            self.length = length
        }
        
        if let numberOfCrewMembersString = json["crew"] as? String, let numberOfCrewMembers = Int(numberOfCrewMembersString) {
            self.numberOfCrewMembers = numberOfCrewMembers
        }
        
        if let numberOfPassengersString = json["passengers"] as? String, let numberOfPassengers = Int(numberOfPassengersString) {
            self.numberOfPassengers = numberOfPassengers
        }
        
        if let maximumAtmosphericSpeedString = json["max_atmosphering_speed"] as? String, let maximumAtmosphericSpeed = Double(maximumAtmosphericSpeedString) {
            self.maximumAtmosphericSpeed = maximumAtmosphericSpeed
        }
    }
}
