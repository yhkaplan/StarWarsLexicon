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

class DataService {

    enum FilmResult {
        case success(FilmService)
        case failure(Error)
    }
    
    enum SWResult {
        case success([String : Any])
        case failure(Error)
    }
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchFilm(at url: URL, completion: @escaping (FilmResult) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            guard error == nil else {
                completion(.failure(error!))
                print(error!)
                return
            }
            
            guard let data = data else {
                //Add in actual error handling here
                completion(.failure("No Data" as! Error))
                print("No data return")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let filmObject = try decoder.decode(FilmService.self, from: data)
                completion(.success(filmObject))
            } catch {
                //Error handling
                print("Big ol' error")
                completion(.failure("No JSON" as! Error))
            }
        }
        task.resume()
    }
    
    func fetchItem(at url: URL, completion: @escaping (SWResult) -> Void) {
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
