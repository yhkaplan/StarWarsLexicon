//
//  PlanetManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

protocol PlanetVCDelegate {
    func updateCount(_ planetCount: Int)
}

class PlanetManager {
    let dataService = DataService()
    
    private var planets = [Planet?]()
    var planetVCDelegate: PlanetVCDelegate
    
    var planetCount = 0 {
        didSet {
            planetVCDelegate.updateCount(planetCount)
        }
    }
    
    init(planetVCDelegate: PlanetVCDelegate) {
        self.planetVCDelegate = planetVCDelegate
        
        //CoreData initializers
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            //Make array equal to fetched contents
            planets = try managedContext.fetch(Planet.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getPlanetCount() {
        if let url = URL(string: "https://swapi.co/api/planets/") {
            dataService.fetchItemCount(url, completion: { (count) in
                if let count = count {
                    for _ in 0..<count {
                        self.planets.append(nil)
                    }
                    
                    self.planetCount = count
                }
            })
        }
    }
    
    private func addPlanet(_ json: [String : Any], to index: Int) -> Planet? {
        
        //One planet shows up as unknown so the following might be necessary (name != "unknown")
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
        
        guard let url = json["url"] as? String else {
            print("Parsing error with planet url")
            return nil
        }
        
        //JSON guards cleared, so test for CoreData prerequisite
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let planet = Planet(entity: Planet.entity(), insertInto: managedContext)
        
        planet.name = name
        planet.climate = climate
        planet.terrain = terrain
        planet.itemURL = url
        
        planet.category = "planet"
        planet.itemName = name
        
        
        if let diameterString = json["diameter"] as? String, let diameter = Double(diameterString) {
            planet.diameter = diameter
        } else {
            planet.diameter = Double(0)
        }
        
        if let rotationPeriodString = json["rotation_period"] as? String, let rotationPeriod = Double(rotationPeriodString) {
            planet.rotationPeriod = rotationPeriod
        } else {
            planet.rotationPeriod = Double(0)
        }
        
        if let orbitalPeriodString = json["orbital_period"] as? String, let orbitalPeriod = Int16(orbitalPeriodString) {
            planet.orbitalPeriod = orbitalPeriod
        } else {
            planet.orbitalPeriod = Int16(0)
        }
        
        if let gravityString = json["gravity"] as? String, let gravity = Double(gravityString) {
            planet.gravity = gravity
        } else {
            planet.gravity = Double(0)
        }
        
        if let populationString = json["population"] as? String, let population = Double(populationString) {
            planet.population = population
        } else {
            planet.population = Double(0)
        }
        
        if let surfaceWaterString = json["surface_water"] as? String, let surfaceWater = Double(surfaceWaterString) {
            planet.surfaceWater = surfaceWater
        } else {
            planet.surfaceWater = Double(0)
        }
        
        //print(planet.description)
        
        do {
            try managedContext.save()
            planets[index] = planet
            return planet
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            print("Could not save planet at index \(planet)")
            return nil
        }
    }
    
    func getPlanet(at index: Int, completion: @escaping (Planet?) -> Void) {
        guard index < planets.count, index >= 0 else {
            completion(nil)
            return
        }
        
        if let planet = planets[index] {
            completion(planet)
        } else {
            if let url = URL(string: "https://swapi.co/api/planets/\(index+1)/") {
                print("Download URL is \(url)")
                dataService.fetchItem(at: url, completion: { (result) in
                    switch result {
                    case let .success(planetJSON):
                        if let planet = self.addPlanet(planetJSON, to: index) {
                            completion(planet)
                        } else {
                            print("JSON parsing error")
                            completion(nil)
                        }
                    case let .failure(error):
                        print(error)
                    }
                })
            }
        }
        completion(nil)
    }
}
