//
//  APIService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/31.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.

import Foundation

//Class that handle URLs and is singleton for passing around urlString info
//The justification for using a singleton:: reason is that then there is no 
//need to pass info through and between View Controllers, only between APIService and the different Manager classes.
//This means that View Controllers and Manager classes are only loaded when necessary, 
//which should be a lighter footprint than had they all been forcefully loaded earlier
class APIService {

    static let sharedInstance = APIService()
    private var characterURLStringCache = [String]()
    private var planetURLStringCache = [String]()
    private var starshipURLStringCache = [String]()
    private var vehicleURLStringCache = [String]()
    
    func generateFilmURLString(for row: Int) -> String {
        //Adding in 1 because there is no film 0
        return baseURLString + URLComponentsStrings.film + "\(row+1)/"
    }
    
    //add Category input parameter
    //This helps avoid duplicate url strings
    func appendURLStringArray(_ array: [String], to category: Category) {
        switch category {
        case .character:
            let nonDuplicateItems = array.filter { !characterURLStringCache.contains($0) }
            characterURLStringCache.append(contentsOf: nonDuplicateItems)
        case .planet:
            let nonDuplicateItems = array.filter { !planetURLStringCache.contains($0) }
            planetURLStringCache.append(contentsOf: nonDuplicateItems)
        case .starship:
            let nonDuplicateItems = array.filter { !starshipURLStringCache.contains($0) }
            starshipURLStringCache.append(contentsOf: nonDuplicateItems)
        case .vehicle:
            let nonDuplicateItems = array.filter { !vehicleURLStringCache.contains($0) }
            vehicleURLStringCache.append(contentsOf: nonDuplicateItems)
        default:
            fatalError("Unexpected category")
        }
    }

    func getURLStringCache(for category: Category) -> [String] {
        switch category {
        case .character:
            return characterURLStringCache
        case .planet:
            return planetURLStringCache
        case .starship:
            return starshipURLStringCache
        case .vehicle:
            return vehicleURLStringCache
        default:
            fatalError("Unexpected category")
        }
    }
    
}
