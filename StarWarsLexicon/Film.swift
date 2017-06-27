//
//  Film.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/09.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Film: SWCategory {

    //Make this conform to error?
    enum initializationError {
        case titleParsingError(Error)
        case episodeIDParsingError(Error)
    }
    
    internal var uid: String { return "film_\(title)" }
    internal var itemName: String { return title }
    
    var title: String
    var episodeID: Int
    var openingCrawl: String
    var director: String
    var producer: String
//    var releaseDate: Date
//    
//    var species: [String]
//    var starships: [String]
//    var vehicles: [String]
//    var characters: [String]
//    var planets: [String]
//    
//    var url: URL
//    var created: Date
//    var edited: Date

    init?(json: [String : Any]) {
        guard let title = json["title"] as? String else {
            print("Parsing error with title ")//"Error: cannot parse title"
            return nil
        }
        
        guard let episodeID = json["episode_id"] as? Int else {
            print("Parsing error with episode id")
            return nil
        }
        
        guard let openingCrawl = json["opening_crawl"] as? String else {
            print("Parsing error with opening crawl")
            return nil
        }
        
        guard let director = json["director"] as? String else {
            print("Parsing error with director")
            return nil
        }
        
        guard let producer = json["producer"] as? String else {
            print("Parsing error with producer")
            return nil
        }
        
        self.title = title
        self.episodeID = episodeID
        self.openingCrawl = openingCrawl
        self.director = director
        self.producer = producer
    }
    
}
