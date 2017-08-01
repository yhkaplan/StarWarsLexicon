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

enum relatedFilmResult {
    case success(Film)
    case failure(Error)
}

enum homeworldResult {
    case success(Planet)
    case failure(Error)
}

enum CharacterResult {
    case success([String : Any])
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
            
//            if let film = Film(json: json) {
//                completion(.success(film))
//            } else {
//                print("Data error")
//                return
//            }
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
            
//            if let homeworld = Planet(json: json) {
//                completion(.success(homeworld))
//            } else {
//                print("Parsing error")
//                return
//            }
        }
        task.resume()
    }
    
    func fetchItem(at url: URL, completion: @escaping (CharacterResult) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            
            guard let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data), let json = rawJSON as? [String : Any] else {
                //JSON structure is different from expected format
                print("JSON structure is different from expected format")
                //completion(.failure(Error("JSON off")))
                return
            }
            
            guard !json.isEmpty else {
                print("Data error")
                completion(.failure("No JSON" as! Error))
                return
            }
            
            completion(.success(json))
            
        }
        task.resume()
    }
    
    func fetchItemCount(_ url: URL, completion: @escaping (Int?) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
        
            guard let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data), let json = rawJSON as? [String : Any], let itemCount = json["count"] as? Int else {
                print("JSON structure differed so count could not be established")
                return
            }
            completion(itemCount)
        
        }
        task.resume()
    }
}
