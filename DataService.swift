//
//  DataService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/07.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

enum Category {
    case film //= "films/"
    case character //= "people/"
//    case planets = "planets/"
//    case species = "species/"
//    case starships = "starships/"
//    case vehicles = "vehicles/"
}

enum Result {
    case filmSuccess([Film], URL?)
    case characterSuccess([Character], URL?)
    //etc
    case failure(Error)
}

class DataService {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchObjects(category: Category, url: URL, completion: @escaping (Result) -> Void) {
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in

            guard let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data), let json = rawJSON as? [String : Any], let resultsArray = json["results"] as? [[String : Any]] else {
                //JSON structure is different from expected format
                print("JSON structure is different from expected format")
                return
            }
            
            switch category {
            case .film:
                //ISN't RESULTS ARRAY A DICTIONARY???
                let finalFilms = resultsArray.flatMap { Film(json: $0) }
                
                if finalFilms.isEmpty && !resultsArray.isEmpty {
                    print("Parsing error")
                }
                
                //No more than ten films for now
                completion(.filmSuccess(finalFilms, nil))
                
            case .character:
                
                let finalCharacters = resultsArray.flatMap { Character(json: $0) }
                
                //Improve error handling
                if finalCharacters.isEmpty && !resultsArray.isEmpty {
                    //No characters parsed
                    print("Parsing error")
                }
                
                //Parse URL
                guard let urlString = json["next"] as? String, let nextURL = URL(string: urlString) else {
                    print("All data retrieved")
                    completion(.characterSuccess(finalCharacters, nil))
                    return
                }
                
                completion(.characterSuccess(finalCharacters, nextURL))
            }
        }
        task.resume()
    }
}
