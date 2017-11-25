//
//  FilmModelTests.swift
//  StarWarsLexiconTests
//
//  Created by Joshua Kaplan on 2017/11/24.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import XCTest
import RealmSwift
import Quick
import Nimble

@testable import StarWarsLexicon

//Tests RealmFilm
class RealmFilmTests: QuickSpec {
    override func spec() {
        describe("Testing if data is saved to mock store") {
            beforeEach {
                //Set up
            }
            afterEach {
                //tear down
            }
            
            context("When objects are initialized in code") {
                it("They should exist in memory with their properties as set") {
                    
                    let director = "George Lucas"
                    let episodeID = 26
                    let itemURL = "http://www.WWDC"
                    let openingCrawl = """
                    Lot's of stuff happened
                    """
                    let producer = "Rick Maccalam?"
                    let releaseDate = "2001/04/29".getDate()!
                    let title = "Return of the Jedi"
                    
                    let charURLs = ["sldfj", "lsdfjl"]
                    let planetURLs = ["jsdlfj", "sdlakfjld"]
                    let starshipURLs = ["skdjf", "skdjf"]
                    let vehicleURLs = ["qiuwyei", "sdc,nc"]
                    
                    let testFilm = RealmFilm(director: director, episodeID: episodeID, itemURL: itemURL, openingCrawl: openingCrawl, producer: producer, releaseDate: releaseDate, title: title, characterURLs: charURLs, planetURLs: planetURLs, starshipURLs: starshipURLs, vehicleURLs: vehicleURLs)
                    
                    expect(testFilm.director).to(equal(director))
                    expect(testFilm.episodeID).to(equal(episodeID))
                    expect(testFilm.itemURL).to(equal(itemURL))
                    expect(testFilm.openingCrawl).to(equal(openingCrawl))
                    expect(testFilm.producer).to(equal(producer))
                    expect(testFilm.releaseDate).to(equal(releaseDate))
                    expect(testFilm.title).to(equal(title))
                    
                    expect(Array(testFilm.characterURLs)).to(equal(charURLs))
                    expect(Array(testFilm.planetURLs)).to(equal(planetURLs))
                    expect(Array(testFilm.starshipURLs)).to(equal(starshipURLs))
                    expect(Array(testFilm.vehicleURLs)).to(equal(vehicleURLs))
                }
            }

            context("When Decodable is used to parse a JSON file") {
                it("is successfully converted to Swift then Realm objects") {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    guard let path = Bundle.main.path(forResource: "TestFilm", ofType: "json") else {
                        fail("JSON file could not be loaded")
                        return
                    }
                    
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    } catch let error {
                        fail("Test failed with following error: \(error)")
                    }
                    
                    let testFilm = try! decoder.decode(RealmFilm.self, from: data)
                    expect(testFilm.title).to(equal("A New Hope"))
                }
            }
        }
    }
}

//Converting Strings to Dates
extension String {
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter.date(from: self)
    }
}
