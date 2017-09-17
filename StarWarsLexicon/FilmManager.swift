//
//  FilmManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

protocol FilmVCDelegate {
    func updateCount(_ filmCount: Int)
}

class FilmManager {
    let dataService = DataService()
    
    //MOC = Managed Object Context
    var moc: NSManagedObjectContext
    
    let sortByEpisodeID = NSSortDescriptor(key: "episodeID", ascending: true)
    
    private var films = [Film?]()
    var filmVCDelegate: FilmVCDelegate?
    
    var filmCount = 0 {
        didSet {
            filmVCDelegate?.updateCount(filmCount)
        }
    }
    
    init(filmVCDelegate: FilmVCDelegate? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not set managed object context")
        }
        self.moc = appDelegate.persistentContainer.viewContext
        
        if filmVCDelegate != nil {
            self.filmVCDelegate = filmVCDelegate

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            do {
                films = try managedContext.fetch(Film.fetchRequest())
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func getFilmCount() {
        if let url = URL(string: baseURLString + URLComponentsStrings.film) {
            dataService.fetchItemCount(url, completion: { (count) in
                DispatchQueue.main.async {
                    if let count = count {
                        for _ in 0..<count {
                            self.films.append(nil)
                        }
                        
                        self.filmCount = count
                    }
                }
            })
        }
    }
    
    private func addFilm(_ service: FilmService, to index: Int) -> Film? {
        
        //Appending new info APIService singleton, using a custom method to avoid duplicates
        APIService.sharedInstance.appendURLStringArray(service.characterURLs, to: .character)
        APIService.sharedInstance.appendURLStringArray(service.planetURLs, to: .planet)
        APIService.sharedInstance.appendURLStringArray(service.starshipURLs, to: .starship)
        APIService.sharedInstance.appendURLStringArray(service.vehicleURLs, to: .vehicle)
        
        //MARK: - JSON guards cleared, so test for CoreData prerequisite
        let film = Film(entity: Film.entity(), insertInto: moc)
        
        film.title = service.title
        film.episodeID = Int16(service.episodeID)
        film.openingCrawl = service.openingCrawl
        film.director = service.director
        film.producer = service.producer
        film.itemURL = service.itemURL
        film.releaseDate = service.releaseDate as NSDate
        
        film.category = "film"
        film.itemName = service.title
        
        //print(film.description)
        
        do {
            try moc.save()
            films[index] = film
            return film
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            print("Could not save film at index \(index)")
            return nil
        }
    }
    
    func getFilm(at index: Int, completion: @escaping (Film?) -> Void) {
        guard index < films.count, index >= 0 else {
            completion(nil)
            return
        }
        
        if let film = films[index] {
            completion(film)
        } else {
            let urlString = APIService.sharedInstance.generateFilmURLString(for: index)
            //This is to check if URL is equal to the url of any other items in the array before downloading
            let doublesArray = films.filter{ urlString == $0?.itemURL }
            
            guard doublesArray.count == 0, let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            //print("Download url is \(url)")
            dataService.fetchFilm(at: url, completion: { (result) in
                switch result {
                case let .success(filmService):
                    if let film = self.addFilm(filmService, to: index) {
                        completion(film)
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
    
    //MARK: - For fetching films to set relationships
    
    func getFilmWith(urlStringArray: [String]) -> NSSet? {
        //MARK: - Setting related films
            
        //Loop through each url, adding CoreData relationship for each one
        var relatedFilms = [Film]()
        
        //Refactor w/ functional programming map or flatmap
        for urlString in urlStringArray {
            getFilmWithURL(urlString, completion: { (result) in
                if let film = result {
                    relatedFilms.append(film)
                }
            })
        }
        
        if relatedFilms.count > 0 {
            //print("Related films are: \(relatedFilms)")
            
            //Convert array to NSArray, then NSSet
            let relatedFilmsNSArray = relatedFilms as NSArray
            let relatedFilmSet = NSSet(array: relatedFilmsNSArray as! [Any])
            //Return value
            return relatedFilmSet
        }
        
        return nil
    }
    
    //Helper function for method above
    private func getFilmWithURL(_ urlString: String, completion: @escaping (Film?) -> Void) {
        //fetch films from core data store, see if any match url using NSPredicate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Film.itemURL), urlString)
        
        var relatedFilms = [Film]()
        
        do {
            relatedFilms = try managedContext.fetch(fetchRequest)
            //films = try managedContext.fetch(Film.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
        
        if relatedFilms.count == 1, let relatedFilm = relatedFilms.first {
            
            completion(relatedFilm)
        
        //If no films match url, then try downloading
        } else {
            //!!TO IMPLEMENT
            //if success downloading, then call addFilm to add to CoreData store
        }
        
        //if no success, return nil
        completion(nil)
    }
}
