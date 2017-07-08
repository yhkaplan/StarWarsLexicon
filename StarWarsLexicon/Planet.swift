//
//  Planet.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/26.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Planet: SWCategory {
    internal var uid: String { return "planet_\(name)" }
    internal var itemName: String { return name }
    
    var name: String
    var climate: String
    var terrain: String
    
    var diameter: Int?
    var rotationPeriod: Int? //rename #ofhours in day?
    var orbitalPeriod: Int? //rename # of days in year?
    var gravity: Float?
    var population: Double?
    var surfaceWater: Int?
    
//    var characters: [Character] //Referred to as residents
//    var films: [Film]
    
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String else {
            print("Parsing error with planet name")
            return nil
        }
        
        guard let climate = json["climate"] as? String else {
            print("Parsing error with planet climate")
            return nil
        }
        
        guard let terrain = json["terrain"] as? String else {
            print("Parsing error with planet terrain")
            return nil
        }
        
        guard name != "unknown" else {
            print("Data error: planet name not defined")
            return nil
        }
        
        self.name = name
        self.climate = climate
        self.terrain = terrain
        
        if let diameterString = json["diameter"] as? String, let diameter = Int(diameterString) {
            self.diameter = diameter
        }
        
        if let rotationPeriodString = json["rotation_period"] as? String, let rotationPeriod = Int(rotationPeriodString) {
            self.rotationPeriod = rotationPeriod
        }
        
        if let orbitalPeriodString = json["orbital_period"] as? String, let orbitalPeriod = Int(orbitalPeriodString) {
            self.orbitalPeriod = orbitalPeriod
        }
        
        if let gravityString = json["gravity"] as? String, let gravity = Float(gravityString) {
            self.gravity = gravity
        }
        
        if let populationString = json["population"] as? String, let population = Double(populationString) {
            self.population = population
        }
        
        if let surfaceWaterString = json["surface_water"] as? String, let surfaceWater = Int(surfaceWaterString) {
            self.surfaceWater = surfaceWater
        }
    }
}
