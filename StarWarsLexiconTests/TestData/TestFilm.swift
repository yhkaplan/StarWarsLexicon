//
//  TestFilm.swift
//  StarWarsLexiconTests
//
//  Created by Joshua Kaplan on 2017/12/01.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import XCTest
import RealmSwift

@testable import StarWarsLexicon

//Using enum here to make namespace more explicit about using test data
enum testFilm {
    static let title = "A New Hope"
    static let director = "George Lucas"
    static let producer = "Gary Kurtz, Rick McCallum"
    static let itemURL = "https://swapi.co/api/films/1/"
    static let episodeID = 4
    static let releaseDate = "1977-05-25".getDate()!
    
    static let openingCrawl = """
    It is a period of civil war.\r\nRebel spaceships, striking\r\nfrom a hidden base, have won\r\ntheir first victory against\r\nthe evil Galactic Empire.\r\n\r\nDuring the battle, Rebel\r\nspies managed to steal secret\r\nplans to the Empire's\r\nultimate weapon, the DEATH\r\nSTAR, an armored space\r\nstation with enough power\r\nto destroy an entire planet.\r\n\r\nPursued by the Empire's\r\nsinister agents, Princess\r\nLeia races home aboard her\r\nstarship, custodian of the\r\nstolen plans that can save her\r\npeople and restore\r\nfreedom to the galaxy....
    """
    
    static let charURLs = [
        "https://swapi.co/api/people/1/",
        "https://swapi.co/api/people/2/",
        "https://swapi.co/api/people/3/",
        "https://swapi.co/api/people/4/",
        "https://swapi.co/api/people/5/",
        "https://swapi.co/api/people/6/",
        "https://swapi.co/api/people/7/",
        "https://swapi.co/api/people/8/",
        "https://swapi.co/api/people/9/",
        "https://swapi.co/api/people/10/",
        "https://swapi.co/api/people/12/",
        "https://swapi.co/api/people/13/",
        "https://swapi.co/api/people/14/",
        "https://swapi.co/api/people/15/",
        "https://swapi.co/api/people/16/",
        "https://swapi.co/api/people/18/",
        "https://swapi.co/api/people/19/",
        "https://swapi.co/api/people/81/"
    ]
    
    static let planetURLs = [
        "https://swapi.co/api/planets/2/",
        "https://swapi.co/api/planets/3/",
        "https://swapi.co/api/planets/1/"
    ]
    
    static let starshipURLs = [
        "https://swapi.co/api/starships/2/",
        "https://swapi.co/api/starships/3/",
        "https://swapi.co/api/starships/5/",
        "https://swapi.co/api/starships/9/",
        "https://swapi.co/api/starships/10/",
        "https://swapi.co/api/starships/11/",
        "https://swapi.co/api/starships/12/",
        "https://swapi.co/api/starships/13/"
    ]
    
    static let vehicleURLs = [
        "https://swapi.co/api/vehicles/4/",
        "https://swapi.co/api/vehicles/6/",
        "https://swapi.co/api/vehicles/7/",
        "https://swapi.co/api/vehicles/8/"
    ]
    
    static let film = RealmFilm(director: director, episodeID: episodeID, itemURL: itemURL, openingCrawl: openingCrawl, producer: producer, releaseDate: releaseDate, title: title, characterURLs: charURLs, planetURLs: planetURLs, starshipURLs: starshipURLs, vehicleURLs: vehicleURLs)
}

