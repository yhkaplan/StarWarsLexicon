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
    case vehicle
}

class DataService {
    
    //Error handling structure for JSON errors
    private enum SWAPIError: Error {
        case noData
        case jsonParsingError(details: String?)
    }
    
    enum SWResult {
        case success(SWService)
        case failure(Error)
    }
    
    //Reusable url session for the methods here
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchItem(at url: URL, for category: Category, completion: @escaping (SWResult) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            guard error == nil else {
                completion(.failure(error!))
                print(error!)
                return
            }
            
            guard let data = data else {
                //Add in actual error handling here
                completion(.failure(SWAPIError.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            //This line helps support the proper date format of 2017-03-01 etc
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                //Handles object differently depending on category
                switch category {
                case .character:
                    let characterService = try decoder.decode(CharacterService.self, from: data)
                    completion(.success(characterService))
                case .film:
                    let filmService = try decoder.decode(FilmService.self, from: data)
                    completion(.success(filmService))
                case .planet:
                    let planetService = try decoder.decode(PlanetService.self, from: data)
                    completion(.success(planetService))
                case .starship:
                    let starshipService = try decoder.decode(StarshipService.self, from: data)
                    completion(.success(starshipService))
                case .vehicle:
                    let vehicleService = try decoder.decode(VehicleService.self, from: data)
                    completion(.success(vehicleService))
                }
                
            } catch {
                completion(.failure(SWAPIError.jsonParsingError(details: nil)))
            }
        }
        task.resume()
    }
    
    func fetchItemCount(_ url: URL, completion: @escaping (Int?) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
        
            //Refactor for Swift 4.0 JSON handling w/ Codable 
            guard let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data), let json = rawJSON as? [String : Any], let itemCount = json["count"] as? Int else {
                //Refactor for better error handling
                print("JSON structure differed so count could not be established")
                completion(nil)
                return
            }
            completion(itemCount)
        
        }
        task.resume()
    }
}
