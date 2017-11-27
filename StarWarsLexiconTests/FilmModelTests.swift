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
    
    //MARK: - Private properties
    
    private let title = "A New Hope"
    private let director = "George Lucas"
    private let producer = "Gary Kurtz, Rick McCallum"
    private let itemURL = "https://swapi.co/api/films/1/"
    private let episodeID = 4
    private let releaseDate = "1977-05-25".getDate()!
    
    private let openingCrawl = """
    It is a period of civil war.\r\nRebel spaceships, striking\r\nfrom a hidden base, have won\r\ntheir first victory against\r\nthe evil Galactic Empire.\r\n\r\nDuring the battle, Rebel\r\nspies managed to steal secret\r\nplans to the Empire's\r\nultimate weapon, the DEATH\r\nSTAR, an armored space\r\nstation with enough power\r\nto destroy an entire planet.\r\n\r\nPursued by the Empire's\r\nsinister agents, Princess\r\nLeia races home aboard her\r\nstarship, custodian of the\r\nstolen plans that can save her\r\npeople and restore\r\nfreedom to the galaxy....
    """
    
    private let charURLs = [
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
    
    private let planetURLs = [
        "https://swapi.co/api/planets/2/",
        "https://swapi.co/api/planets/3/",
        "https://swapi.co/api/planets/1/"
    ]
    
    private let starshipURLs = [
        "https://swapi.co/api/starships/2/",
        "https://swapi.co/api/starships/3/",
        "https://swapi.co/api/starships/5/",
        "https://swapi.co/api/starships/9/",
        "https://swapi.co/api/starships/10/",
        "https://swapi.co/api/starships/11/",
        "https://swapi.co/api/starships/12/",
        "https://swapi.co/api/starships/13/"
    ]
    
    private let vehicleURLs = [
        "https://swapi.co/api/vehicles/4/",
        "https://swapi.co/api/vehicles/6/",
        "https://swapi.co/api/vehicles/7/",
        "https://swapi.co/api/vehicles/8/"
    ]
    
    //MARK: - Actual test code
    
    
    
    override func spec() {
        describe("Testing if data is saved to mock store") {
            context("When objects are initialized in code") {
                it("They should exist in memory with their properties as set") {
                    let testFilm = RealmFilm(director: self.director, episodeID: self.episodeID, itemURL: self.itemURL, openingCrawl: self.openingCrawl, producer: self.producer, releaseDate: self.releaseDate, title: self.title, characterURLs: self.charURLs, planetURLs: self.planetURLs, starshipURLs: self.starshipURLs, vehicleURLs: self.vehicleURLs)
                    
                    testProperties(of: testFilm)
                }
            }

            context("When Decodable is used to parse a JSON file") {
                it("has all properties read correctly") {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    guard let path = Bundle(for: type(of: self)).path(forResource: "TestFilm", ofType: "json") else {
                        fail("JSON file could not be loaded")
                        return
                    }
                    
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        let testFilm = try! decoder.decode(RealmFilm.self, from: data)
                        
                        expect(testFilm).toNot(beNil())
                        
                        testProperties(of: testFilm)
                    } catch let error {
                        fail("Test failed with following error: \(error)")
                    }
                }
            }
            
            //Double check to make sure this contains all properties
            func testProperties(of testFilm: RealmFilm) {
                //Main properties
                expect(testFilm.title).to(equal(title))
                expect(testFilm.episodeID).to(equal(episodeID))
                expect(testFilm.openingCrawl).to(equal(openingCrawl))
                expect(testFilm.director).to(equal(director))
                expect(testFilm.producer).to(equal(producer))
                expect(testFilm.releaseDate).to(equal(releaseDate))
                expect(testFilm.itemURL).to(equal(itemURL))
                
                //Related item properties
                expect(Array(testFilm.characterURLs)).to(equal(charURLs))
                expect(Array(testFilm.planetURLs)).to(equal(planetURLs))
                expect(Array(testFilm.starshipURLs)).to(equal(starshipURLs))
                expect(Array(testFilm.vehicleURLs)).to(equal(vehicleURLs))
            }
        }
    }
}

//MARK: - Extension for converting Strings to Dates
//Must relocate!
extension String {
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter.date(from: self)
    }
}
