//
//  DataService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/07.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

enum Category {
    case film
    case character
    case starship
    case planet
    case species
    case vehicle
}

enum Result {
    case filmSuccess([Film], URL?)
    case characterSuccess([Character], URL?)
    case starshipSuccess([Starship], URL?)
    case planetSuccess([Planet], URL?)
    case speciesSuccess([Species], URL?)
    case vehicleSuccess([Vehicle], URL?)
    case failure(Error)
}

enum relatedFilmResult {
    case success(Film)
    case failure(Error)
}

enum homeworldResult {
    case success(Planet)
    case failure(Error)
}

class DataService {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchRelatedFilm(from filmURL: URL, completion: @escaping (relatedFilmResult) -> Void) {
        
        let request = URLRequest(url: filmURL)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data), let json = rawJSON as? [String : Any] else {
                //JSON structure is different from expected format
                print("JSON structure is different from expected format")
                return
            }
            
            guard !json.isEmpty else {
                print("Data error")
                return
            }
            
            if let film = Film(json: json) {
                completion(.success(film))
            } else {
                print("Data error")
                return
            }
        }
        task.resume()
    }
    
    func fetchHomeworld(from planetURL: URL, completion: @escaping (homeworldResult) -> Void) {
        
        let request = URLRequest(url: planetURL)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data), let json = rawJSON as? [String : Any] else {
                print("JSON structure is different from expected format")
                return
            }
            
            guard !json.isEmpty else {
                print("Data error")
                return
            }
            
            if let homeworld = Planet(json: json) {
                completion(.success(homeworld))
            } else {
                print("Parsing error")
                return
            }
        }
        task.resume()
    }
    
    func fetchObjects(category: Category, url: URL, completion: @escaping (Result) -> Void) {
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in

            guard let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data), let json = rawJSON as? [String : Any], let resultsArray = json["results"] as? [[String : Any]] else {
                //JSON structure is different from expected format
                print("JSON structure is different from expected format")
                return
            }
            
            guard !resultsArray.isEmpty else {
                completion(.failure("API error" as! Error))//Revise this
                return
            }
            
            switch category {
            case .film:
                //ISN't RESULTS ARRAY A DICTIONARY???
                let finalFilms = resultsArray.flatMap { Film(json: $0) }
                //Assumption: because flatmap returns no nil items and final is not optional, no check for empty array required
                //Guard let preferable??
                
                //No more than ten films for now
                completion(.filmSuccess(finalFilms, nil))
                
            case .character:
                let finalCharacters = resultsArray.flatMap { Character(json: $0) }
                
                guard let urlString = json["next"] as? String, let nextURL = URL(string: urlString) else {
                    print("All data retrieved")
                    completion(.characterSuccess(finalCharacters, nil))
                    return
                }
                
                completion(.characterSuccess(finalCharacters, nextURL))
                
            case .starship:
                let finalStarships = resultsArray.flatMap { Starship(json: $0) }
                
                guard let urlString = json["next"] as? String, let nextURL = URL(string: urlString) else {
                    print("All data retrieved")
                    completion(.starshipSuccess(finalStarships, nil))
                    return
                }
                
                print(finalStarships)
                
                completion(.starshipSuccess(finalStarships, nextURL))
                
            case .planet:
                let finalPlanets = resultsArray.flatMap { Planet(json: $0) }
                
                guard let urlString = json["next"] as? String, let nextURL = URL(string: urlString) else {
                    print("All data retrieved")
                    completion(.planetSuccess(finalPlanets, nil))
                    return
                }
                
                completion(.planetSuccess(finalPlanets, nextURL))
            case .species:
                let finalSpecies = resultsArray.flatMap { Species(json: $0) }
                
                guard let urlString = json["next"] as? String, let nextURL = URL(string: urlString) else {
                    print("All data retrieved")
                    completion(.speciesSuccess(finalSpecies, nil))
                    return
                }
                
                completion(.speciesSuccess(finalSpecies, nextURL))
            case .vehicle:
                let finalVehicles = resultsArray.flatMap { Vehicle(json: $0) }
                
                guard let urlString = json["next"] as? String, let nextURL = URL(string: urlString) else {
                    print("All data retrieved")
                    completion(.vehicleSuccess(finalVehicles, nil))
                    return
                }
                
                completion(.vehicleSuccess(finalVehicles, nextURL))
            }
        }
        task.resume()
    }
}
