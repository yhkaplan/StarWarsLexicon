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
    
    internal var category: Category { return .film }
    internal var itemName: String { return title }
    
    var title: String
    var episodeID: Int
    var openingCrawl: String
    var director: String
    var producer: String
    var releaseDate: Date
    var itemURL: URL
//    
//    var species: [String]
//    var starships: [String]
//    var vehicles: [String]
//    var characters: [String]
//    var planets: [String]

    init?(json: [String : Any]) {
        guard let title = json["title"] as? String else {
            print("Parsing error with title ")
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
        
        guard let urlString = json["url"] as? String, let url = URL(string: urlString) else {
            print("Parsing error with url")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let releaseDateString = json["release_date"] as? String, let releaseDate = formatter.date(from: releaseDateString) else {
            print("Parsing error with release date")
            return nil
        }
        
        self.title = title
        self.episodeID = episodeID
        self.openingCrawl = openingCrawl
        self.director = director
        self.producer = producer
        self.itemURL = url
        self.releaseDate = releaseDate
    }
}
