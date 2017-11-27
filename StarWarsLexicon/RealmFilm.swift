//
//  RealmFilm.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/11/24.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import RealmSwift

/*
 This struct is to account for the API format.
 All objects on a given page are located in an array with the dict key: "results"
*/
struct FilmList: Decodable {
    let films: [RealmFilm]
    let nextPage: String? //This is to both grab the next page and see if it is nil
    
    private enum CodingKeys: String, CodingKey {
        case films = "results"
        case nextPage = "next"
    }
}

//Make this conform to Decodable and test w/ a JSON file
//Also make this conform to SWService or SWCategory
class RealmFilm: Object, Decodable {
    @objc dynamic var director = ""
    @objc dynamic var episodeID = 0
    @objc dynamic var itemURL = ""
    @objc dynamic var openingCrawl = ""
    @objc dynamic var producer = ""
    @objc dynamic var releaseDate = Date()
    @objc dynamic var title = ""

    /* From Realm documentation at: https://realm.io/docs/swift/latest/
     Relationships and nested data structures are modeled by including properties
     of the target type or Lists for typed list of objects.
     List instances can also be used to model collections of primitive values
     (for example, an array of strings or integers).
    */
    let characterURLs = List<String>() //Let or var?
    let planetURLs = List<String>() //Let or var?
    let starshipURLs = List<String>() //Let or var?
    let vehicleURLs = List<String>() //Let or var?
    
    //Required for Realm
    convenience init(director: String, episodeID: Int, itemURL: String, openingCrawl: String, producer: String, releaseDate: Date, title: String, characterURLs: [String], planetURLs: [String], starshipURLs: [String], vehicleURLs: [String]) {
        self.init()

        self.director = director
        self.episodeID = episodeID
        self.itemURL = itemURL
        self.openingCrawl = openingCrawl
        self.producer = producer
        self.releaseDate = releaseDate
        self.title = title

        self.characterURLs.append(objectsIn: characterURLs)
        self.planetURLs.append(objectsIn: planetURLs)
        self.starshipURLs.append(objectsIn: starshipURLs)
        self.vehicleURLs.append(objectsIn: vehicleURLs)
    }
    
    //Required for conforming to Decodable protocol
    //Required for Realm because Realm data types doesn't appear to natively support Codable yet
    //For more info, see: https://github.com/realm/realm-cocoa/issues/5012
    //Concerning List type support, I referred to this: https://stackoverflow.com/questions/45452833/how-to-use-list-type-with-codable-realmswift
    //Ideally, this should be refactored into a generic extension to Realm
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.director = try container.decode(String.self, forKey: .director)
        self.episodeID = try container.decode(Int.self, forKey: .episodeID) //Test Int support
        self.itemURL = try container.decode(String.self, forKey: .itemURL)
        self.openingCrawl = try container.decode(String.self, forKey: .openingCrawl)
        self.producer = try container.decode(String.self, forKey: .producer)
        self.releaseDate = try container.decode(Date.self, forKey: .releaseDate) //Test Date support
        self.title = try container.decode(String.self, forKey: .title)
        
        let charURLs = try container.decode([String].self, forKey: .characterURLs)
        self.characterURLs.append(objectsIn: charURLs)
        let planetURLs = try container.decode([String].self, forKey: .planetURLs)
        self.planetURLs.append(objectsIn: planetURLs)
        let starshipsURLs = try container.decode([String].self, forKey: .starshipURLs)
        self.starshipURLs.append(objectsIn: starshipsURLs)
        let vehicleURLs = try container.decode([String].self, forKey: .vehicleURLs)
        self.vehicleURLs.append(objectsIn: vehicleURLs)
    }
    
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

