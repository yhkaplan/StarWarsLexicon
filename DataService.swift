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
    
    //Error handling structure for JSON errors
    private enum SWAPIError: Error {
        case noData
        case jsonParsingError(details: String?)
    }

    enum FilmResult {
        case success(FilmService)
        case failure(Error)
    }
    
    enum SWResult {
        case success([String : Any])
        case failure(Error)
    }
    
    //Reusable url session for the methods here
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
                completion(.failure(SWAPIError.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            //This line helps support the proper date format of 2017-03-01 etc
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let filmObject = try decoder.decode(FilmService.self, from: data)
                completion(.success(filmObject))
            } catch {
                completion(.failure(SWAPIError.jsonParsingError(details: nil)))
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
                completion(.failure(SWAPIError.jsonParsingError(details: "JSON structure is different from expected format")))
                return
            }
            
            guard !json.isEmpty else {
                completion(.failure(SWAPIError.jsonParsingError(details: nil)))
                return
            }
            
            completion(.success(json))
            
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
