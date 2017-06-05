//
//  SWAPI.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidJSONData
}

struct SWAPI {
    
    //If data here is valid JSON data, then it's referred to the right area. 
    //Otherwise, the error is referred on.
    static func films(fromJSON data: Data) -> Result {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            //Must adapt this for each URL path: eg. characters, worlds, etc.
            guard let jsonDictionary = jsonObject as? [AnyHashable:Any], let filmArray = jsonDictionary["results"] as? [[String:Any]] else {
                //JSON structure is different from expected format
                return .failure(APIError.invalidJSONData)
            }
            
            var finalFilms = [Film]()
            
            for filmJSON in filmArray {
                if let film = film(fromJSON: filmJSON) {
                    finalFilms.append(film)
                }
            }
            
            if finalFilms.isEmpty && !filmArray.isEmpty {
                //No films could be parsed
                return .failure(APIError.invalidJSONData)
            }
            
            return .filmSuccess(finalFilms)
            
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func film(fromJSON json: [String : Any]) -> Film? {
        guard let title = json["title"] as? String, let episodeID = json["episode_id"] as? Int, let openingCrawl = json["opening_crawl"] as? String else {
            
            //Not enough information available to create Film
            return nil
        }
        return Film(title: title, episodeID: episodeID, openingCrawl: openingCrawl)
    }
}
