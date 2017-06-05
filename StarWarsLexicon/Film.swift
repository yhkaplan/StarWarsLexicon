//
//  Film.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/09.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

struct Film: SWCategory {
    
    internal var uid: String { return "film" + "\(episodeID)" }
    
    var title: String
    var episodeID: Int
    var openingCrawl: String
//    var director: String
//    var producer: String
//    var release_date: Date
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

    //Getters and setters needed?
    
}
