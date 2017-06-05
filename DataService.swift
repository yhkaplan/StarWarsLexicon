//
//  DataService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/07.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

enum Category: String {
    case films = "films/"
    case people = "people/"
    case planets = "planets/"
    case species = "species/"
    case starships = "starships/"
    case vehicles = "vehicles/"
}

enum SWAPIError {
    case invalidJSONData
}

enum Result {
    case filmSuccess([Film])
    //case characterSuccess([Character])
    //etc
    case failure(Error)
}

class DataService {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func processObjectRequest(data: Data?, error: Error?) -> Result {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return SWAPI.films(fromJSON: jsonData)
    }
    
    func fetchObjects(completion: @escaping (Result)  -> Void) {
        
        let url = URL(string: "https://swapi.co/api/films/")
        //To change this to refer to "SWAPI.filmBaseURL, SWAPI.planetBaseURL..." later
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            let result = self.processObjectRequest(data: data, error: error)
            
            //This is the whole key to calling the contained expression on the main thread
            OperationQueue.main.addOperation {
               completion(result) 
            }
            
        }
        task.resume()
    }
}
