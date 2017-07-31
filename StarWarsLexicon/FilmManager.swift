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
        
        //CoreData methods
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
    
    private func addFilm(_ json: [String : Any], to index: Int) -> Film? {
        if let film = Film(json: json) {
            films[index] = film
            return film
        }
        return nil
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
