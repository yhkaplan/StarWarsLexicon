//
//  FilmService.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/09/16.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct FilmService: Decodable, SWService {
    let director: String
    let episodeID: Int
    let itemURL: String
    let openingCrawl: String
    let producer: String
    let releaseDate: Date //This probably needs some extra work to convert
    let title: String
    
    let characterURLs: [String]
    let planetURLs: [String]
    let starshipURLs: [String]
    let vehicleURLs: [String]
    
    //Enum to help codable convert json to objects
    private enum CodingKeys: String, CodingKey {
        case director
        case episodeID = "episode_id"
        case itemURL = "url"
        case openingCrawl = "opening_crawl"
        case producer
        case releaseDate = "release_date"
        case title
        
        case characterURLs = "characters"
        case planetURLs = "planets"
        case starshipURLs = "starships"
        case vehicleURLs = "vehicles"
    }
}
