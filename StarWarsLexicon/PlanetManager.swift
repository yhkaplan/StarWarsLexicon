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
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        do {
//            //Make array equal to fetched contents
//            characters = try managedContext.fetch(Character.fetchRequest())
//        } catch let error as NSError {
//            print(error)
//        }
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
        
        //Add JSON parsing here for CoreData
        
        if let planet = Planet(json: json) {
            planets[index] = planet
            return planet
        }
        return nil
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
