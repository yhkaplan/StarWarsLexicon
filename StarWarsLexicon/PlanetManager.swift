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
    let filmManager = FilmManager()
    
    //MOC = Managed Object Context
    var moc: NSManagedObjectContext
    
    let sortByName = NSSortDescriptor(key: "itemName", ascending: true)
    
    private var planetURLCache = [String]()
    private var planetURLCount: Int { return planetURLCache.count }
    
    private var planets = [Planet?]()
    var planetCount: Int { return planets.count }
    
    init() {
        //Set NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not set Managed Object Context")
        }
        self.moc = appDelegate.persistentContainer.viewContext
        
        planetURLCache = APIService.sharedInstance.getURLStringCache(for: .planet)
        
        loadLocalPlanets()
        
        let countDifference = planetURLCount - planetCount
        
        if countDifference > 0 {
            for _ in 0..<countDifference {
                planets.append(nil)
            }
        }
    }
    
    func loadLocalPlanets() {
        do {
            //Make array equal to fetched contents
            planets = try moc.fetch(Planet.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func addPlanet(_ service: PlanetService, to index: Int) -> Planet? {
        
        let planet = Planet(entity: Planet.entity(), insertInto: moc)
        
        planet.name = service.name
        planet.climate = service.climate
        planet.terrain = service.terrain
        planet.itemURL = service.url
        
        planet.category = "planet"
        planet.itemName = service.name
        
        //MARK: - Setting related films
        if let relatedFilmSet = filmManager.getFilmWith(urlStringArray: service.toFilm) {
            //Set value
            planet.toFilm = relatedFilmSet
        }
    
        planet.diameter = Double(service.diameter) ?? Double(-1)
        planet.rotationPeriod = Double(service.rotationPeriod) ?? Double(-1)
        planet.orbitalPeriod = Int16(service.orbitalPeriod) ?? Int16(-1)
        planet.gravity = Double(service.gravity) ?? Double(-1)
        planet.population = Double(service.population) ?? Double(-1)
        planet.surfaceWater = Double(service.surfaceWater) ?? Double(-1)
        
        //print(planet.description)
        
        do {
            try moc.save()
            planets[index] = planet
            return planet
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            print("Could not save planet at index \(planet)")
            return nil
        }
    }
    
    //MARK: - Used for search
    
    func loadPlanets(with text: String) {
        //Create fetch request
        let fetchRequest: NSFetchRequest<Planet> = Planet.fetchRequest()
        
        //Search predicate
        //C in CD means case insensitive, d means diacritic insensitive
        //"%K CONTAINS[cd] %@" = search for keypath containing input
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Planet.itemName), text)
        
        fetchRequest.sortDescriptors = [sortByName]
        
        do {
            planets = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
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
            dataService.fetchItem(at: url, for: .planet, completion: { (result) in
                switch result {
                case let .success(planetService):
                    if let planetService = planetService as? PlanetService {
                        if let planet = self.addPlanet(planetService, to: index) {
                            completion(planet)
                        } else {
                            print("JSON parsing error")
                            completion(nil)
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            })
            completion(nil)
        }
    }
}
