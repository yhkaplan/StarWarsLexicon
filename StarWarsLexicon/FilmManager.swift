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
    
    private func convertToDate(from string: String) -> NSDate? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.date(from: string) as NSDate?
    }
    
    private func addFilm(_ json: [String : Any], to index: Int) -> Film? {
        
        guard let title = json["title"] as? String else {
            print("Parsing error with title ")
            return nil
        }
        
        guard let episodeID = json["episode_id"] as? Int16 else {
            print("Parsing error with episode id")
            return nil
        }
        
        guard let openingCrawl = json["opening_crawl"] as? String else {
            print("Parsing error with opening crawl")
            return nil
        }
        
        guard let director = json["director"] as? String else {
            print("Parsing error with director")
            return nil
        }
        
        guard let producer = json["producer"] as? String else {
            print("Parsing error with producer")
            return nil
        }
        
        guard let url = json["url"] as? String else {
            print("Parsing error with url")
            return nil
        }
        
        guard let releaseDateString = json["release_date"] as? String, let releaseDate = convertToDate(from: releaseDateString) else {
            print("Parsing error with release date")
            return nil
        }
        
        //MARK: - Checks for other objects. This url data is then passed to other areas
        
        guard let characterURLStrings = json["characters"] as? [String] else {
            print("Parsing error with character URLs")
            return nil
        }
        
        guard let planetURLStrings = json["planets"] as? [String] else {
            print("Parsing error with planet URLs")
            return nil
        }
        
        guard let starshipURLStrings = json["starships"] as? [String] else {
            print("Parsing error with starship URLs")
            return nil
        }
        
        guard let vehicleURLStrings = json["vehicles"] as? [String] else {
            print("Parsing error with vehicle URLs")
            return nil
        }
        
        //Appending new info APIService singleton, using a custom method to avoid duplicates
        APIService.sharedInstance.appendURLStringArray(characterURLStrings, to: .character)
        APIService.sharedInstance.appendURLStringArray(planetURLStrings, to: .planet)
        APIService.sharedInstance.appendURLStringArray(starshipURLStrings, to: .starship)
        APIService.sharedInstance.appendURLStringArray(vehicleURLStrings, to: .vehicle)
        
        //MARK: - JSON guards cleared, so test for CoreData prerequisite
        let film = Film(entity: Film.entity(), insertInto: moc)
        
        film.title = title
        film.episodeID = episodeID
        film.openingCrawl = openingCrawl
        film.director = director
        film.producer = producer
        film.itemURL = url
        film.releaseDate = releaseDate
        
        film.category = "film"
        film.itemName = title
        
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
            dataService.fetchItem(at: url, completion: { (result) in
                switch result {
                case let .success(filmJSON):
                    if let film = self.addFilm(filmJSON, to: index) {
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
