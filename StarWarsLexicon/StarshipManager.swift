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
    
    func loadLocalStarships() {
        do {
            starships = try moc.fetch(Starship.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func addStarship(_ service: StarshipService, to index: Int) -> Starship? {
        
        let starship = Starship(entity: Starship.entity(), insertInto: moc)
        
        starship.name = service.name
        starship.model = service.model
        starship.starshipClass = service.starshipClass
        starship.manufacturer = service.manufacturer
        starship.itemURL = service.url
        
        starship.itemName = service.name
        starship.category = "starship"
        
        //MARK: - Setting related films
        if let relatedFilmSet = filmManager.getFilmWith(urlStringArray: service.toFilm) {
            //Set value
            starship.toFilm = relatedFilmSet
        }
        
        starship.costInCredits = Double(service.costInCredits) ?? Double(-1)
        starship.length = Double(service.length) ?? Double(-1)
        starship.numberOfCrewMembers = Double(service.numberOfCrewMembers) ?? Double(-1)
        starship.numberOfPassengers = Double(service.numberOfPassengers) ?? Double(-1)
        starship.maxAtmosphericSpeed = Double(service.maxAtmosphericSpeed) ?? Double(-1)
        starship.hyperdriveRating = Double(service.hyperDriveRating) ?? Double(-1)
        
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
    
    //MARK: - Used for search 
    
    func loadStarships(with text: String) {
        //Create fetch request
        let fetchRequest: NSFetchRequest<Starship> = Starship.fetchRequest()
        
        //Add predicate with text string
        //C in CD means case insensitive, d means diacritic insensitive
        //"%K CONTAINS[cd] %@" = search for keypath containing input
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Starship.itemName), text)
        
        fetchRequest.sortDescriptors = [sortByName]
        
        do {
            starships = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
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
            dataService.fetchItem(at: url, for: .starship, completion: { (result) in
                switch result {
                case let .success(starshipService):
                    if let starshipService = starshipService as? StarshipService {
                        if let starship = self.addStarship(starshipService, to: index) {
                            completion(starship)
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
