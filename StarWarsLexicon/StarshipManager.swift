//
//  StarshipManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit
import CoreData

protocol StarshipVCDelegate {
    func updateCount(_ starshipCount: Int)
}

//Not parsing starships properly!!

class StarshipManager {
    let dataService = DataService()
    
    private var starships = [Starship?]()
    var starshipVCDelegate: StarshipVCDelegate
    
    var starshipCount = 0 {
        didSet {
            starshipVCDelegate.updateCount(starshipCount)
        }
    }
    
    init(starshipVCDelegate: StarshipVCDelegate) {
        self.starshipVCDelegate = starshipVCDelegate
        
        //Add CoreData initializers here
    }
    
    func getStarshipCount() {
        if let url = URL(string: "https://swapi.co/api/starships/") {
            dataService.fetchItemCount(url, completion: { (count) in
                if let count = count {
                    for _ in 0..<count {
                        self.starships.append(nil)
                    }
                    
                    self.starshipCount = count
                }
            })
        }
    }
    
    private func addStarship(_ json: [String : Any], to index: Int) -> Starship? {
        if let starship = Starship(json: json) {
            starships[index] = starship
            return starship
        }
        return nil
    }
    
    func getStarship(at index: Int, completion: @escaping (Starship?) -> Void) {
        guard index < starships.count, index >= 0 else {
            completion(nil)
            return
        }
        
        if let starship = starships[index] {
            completion(starship)
        } else {
            if let url = URL(string: "https://swapi.co/api/starships/\(index+1)/") {
                print("Download url is \(url)")
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
            }
        }
        completion(nil)
    }
}
