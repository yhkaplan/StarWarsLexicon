//
//  PlanetManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

class PlanetManager {
    let dataService = DataService()
    
    private var planetURLCache = [String]()
    private var planetURLCount: Int { return planetURLCache.count }
    
    private var planets = [Planet?]()
    var planetCount: Int { return planets.count }
    
    init() {
        planetURLCache = APIService.sharedInstance.getURLStringCache(for: .planet)
        
        loadLocalPlanets()
        
        let countDifference = planetURLCount - planetCount
        
        if countDifference > 0 {
            for _ in 0..<countDifference {
                planets.append(nil)
            }
        }
    }
    
    private func loadLocalPlanets() {
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
    
    private func addPlanet(_ json: [String : Any], to index: Int) -> Planet? {
        
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
            planet.diameter = Double(-1)
        }
        
        if let rotationPeriodString = json["rotation_period"] as? String, let rotationPeriod = Double(rotationPeriodString) {
            planet.rotationPeriod = rotationPeriod
        } else {
            planet.rotationPeriod = Double(-1)
        }
        
        if let orbitalPeriodString = json["orbital_period"] as? String, let orbitalPeriod = Int16(orbitalPeriodString) {
            planet.orbitalPeriod = orbitalPeriod
        } else {
            planet.orbitalPeriod = Int16(-1)
        }
        
        if let gravityString = json["gravity"] as? String, let gravity = Double(gravityString) {
            planet.gravity = gravity
        } else {
            planet.gravity = Double(-1)
        }
        
        if let populationString = json["population"] as? String, let population = Double(populationString) {
            planet.population = population
        } else {
            planet.population = Double(-1)
        }
        
        if let surfaceWaterString = json["surface_water"] as? String, let surfaceWater = Double(surfaceWaterString) {
            planet.surfaceWater = surfaceWater
        } else {
            planet.surfaceWater = Double(-1)
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
            
            let urlString =  planetURLCache[index]
            
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            //print("Download URL is \(url)")
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
            completion(nil)
        }
    }
}
