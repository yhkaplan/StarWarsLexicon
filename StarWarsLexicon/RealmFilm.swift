//
//  RealmFilm.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/11/24.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import RealmSwift

//Make this conform to Decodable and test w/ a JSON file
//Also make this conform to SWService or SWCategory
class RealmFilm: Object {
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
    let planetURLs = List<String>()
    let starshipURLs = List<String>()
    let vehicleURLs = List<String>()
    
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
}

