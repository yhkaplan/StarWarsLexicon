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
    
    private var films = [Film?]()
    var filmVCDelegate: FilmVCDelegate
    
    var filmCount = 0 {
        didSet {
            filmVCDelegate.updateCount(filmCount)
        }
    }
    
    init(filmVCDelegate: FilmVCDelegate) {
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
    
    func getFilmCount() {
        if let url = URL(string: "https://swapi.co/api/films/") {
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
        
        //JSON guards cleared, so test for CoreData prerequisite
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let film = Film(entity: Film.entity(), insertInto: managedContext)
        
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
            try managedContext.save()
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
            if let url = URL(string: "https://swapi.co/api/films/\(index+1)/") {
                print("Download url is \(url)")
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
            }
        }
        completion(nil)
    }
}
