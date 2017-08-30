//
//  StarshipManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

class StarshipManager {
    let dataService = DataService()
    let filmManager = FilmManager()
    
    //MOC = Managed Object Context
    var moc: NSManagedObjectContext
    
    let sortByName = NSSortDescriptor(key: "itemName", ascending: true)
    
    private var starshipURLCache = [String]()
    private var starshipURLCount: Int { return starshipURLCache.count }
    
    private var starships = [Starship?]()
    var starshipCount: Int { return starships.count }
    
    init() {
        //Set NSManaged Object Context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not set Managed Object Context")
        }
        self.moc = appDelegate.persistentContainer.viewContext
        
        starshipURLCache = APIService.sharedInstance.getURLStringCache(for: .starship)
        
        loadLocalStarships()
        
        let countDifference = starshipURLCount - starshipCount
        
        if countDifference > 0 {
            for _ in 0..<countDifference {
                starships.append(nil)
            }
        }
    }
    
    private func loadLocalStarships() {
        do {
            starships = try moc.fetch(Starship.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func addStarship(_ json: [String : Any], to index: Int) -> Starship? {
        
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
        
        guard let url = json["url"] as? String else {
            print("Parsing error with starship url")
            return nil
        }
        
        //JSON guards cleared, so test for CoreData prerequisite
        let starship = Starship(entity: Starship.entity(), insertInto: moc)
        
        starship.name = name
        starship.model = model
        starship.starshipClass = starshipClass
        starship.manufacturer = manufacturer
        starship.itemURL = url
        
        starship.itemName = name
        starship.category = "starship"
        
        //MARK: - Setting related films
        if let filmURLStrings = json["films"] as? [String] {
            if let relatedFilmSet = filmManager.getFilmWith(urlStringArray: filmURLStrings) {
                //Set value
                starship.toFilm = relatedFilmSet
            }
        }
        
        if let costInCreditsString = json["cost_in_credits"] as? String, let costInCredits = Double(costInCreditsString) {
            starship.costInCredits = costInCredits
        } else {
            starship.costInCredits = Double(-1)
        }
        
        if let lengthString = json["length"] as? String, let length = Double(lengthString) {
            starship.length = length
        } else {
            starship.length = Double(-1)
        }
        
        if let numberOfCrewMembersString = json["crew"] as? String, let numberOfCrewMembers = Double(numberOfCrewMembersString) {
            starship.numberOfCrewMembers = numberOfCrewMembers
        } else {
            starship.numberOfCrewMembers = Double(-1)
        }
        
        if let numberOfPassengersString = json["passengers"] as? String, let numberOfPassengers = Double(numberOfPassengersString) {
            starship.numberOfPassengers = numberOfPassengers
        } else {
            starship.numberOfPassengers = Double(-1)
        }
        
        if let maxAtmosphericSpeedString = json["max_atmosphering_speed"] as? String, let maxAtmosphericSpeed = Double(maxAtmosphericSpeedString) {
            starship.maxAtmosphericSpeed = maxAtmosphericSpeed
        } else {
            starship.maxAtmosphericSpeed = Double(-1)
        }
        
        if let hyperdriveRatingString = json["hyperdrive_rating"] as? String, let hyperdriveRating = Double(hyperdriveRatingString) {
            starship.hyperdriveRating = hyperdriveRating
        } else {
            starship.hyperdriveRating = Double(-1)
        }
        
        //print(starship.description)
        
        do {
            try moc.save()
            starships[index] = starship
            return starship
        } catch let error as NSError {
            print("Could not save \(error), \(error)")
            print("Could not save starship at index \(index)")
            return nil
        }
    }
    
    func getStarship(at index: Int, completion: @escaping (Starship?) -> Void) {
        guard index < starships.count, index >= 0 else {
            completion(nil)
            return
        }
        
        if let starship = starships[index] {
            completion(starship)
        } else {
            let urlString = starshipURLCache[index]
            
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            //print("Download url is \(url)")
            dataService.fetchItem(at: url, completion: { (result) in
                switch result {
                case let .success(starshipJSON):
                    //switch to main thread?
                    if let starship = self.addStarship(starshipJSON, to: index) {
                        completion(starship)
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
