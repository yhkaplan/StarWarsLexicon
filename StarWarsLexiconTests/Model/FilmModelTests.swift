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
    
    // MARK: - Actual test code
    
    override func spec() {
        describe("Testing if data is saved to mock store") {
            context("When objects are initialized in code") {
                it("They should exist in memory with their properties as set") {
                    let film = testFilm.film
                    testProperties(of: film)
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
                        let testFilm = try decoder.decode(RealmFilm.self, from: data)
                        
                        expect(testFilm).toNot(beNil())
                        testProperties(of: testFilm)
                    } catch let error {
                        fail("Test failed with following error: \(error)")
                    }
                }
            }
            
            context("When a FilmList (results array) json is processed") {
                it("is parsed successfully with Decodable") {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    guard let path = Bundle(for: type(of: self)).path(forResource: "TestFilmList", ofType: "json") else {
                        fail("JSON file could not be loaded")
                        return
                    }
                    
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        let testFilmList = try decoder.decode(FilmList.self, from: data)
                        
                        expect(testFilmList).toNot(beNil())
                        //The first film happens to be a New Hope
                        testProperties(of: testFilmList.films[0])
                    } catch let error {
                        fail("Test failed with following error: \(error)")
                    }
                }
            }
            
            //Double check to make sure this contains all properties
            func testProperties(of filmBeingTested: RealmFilm) {
                //Main properties
                expect(filmBeingTested.title).to(equal(testFilm.title))
                expect(filmBeingTested.episodeID).to(equal(testFilm.episodeID))
                expect(filmBeingTested.openingCrawl).to(equal(testFilm.openingCrawl))
                expect(filmBeingTested.director).to(equal(testFilm.director))
                expect(filmBeingTested.producer).to(equal(testFilm.producer))
                expect(filmBeingTested.releaseDate).to(equal(testFilm.releaseDate))
                expect(filmBeingTested.itemURL).to(equal(testFilm.itemURL))
                
                //Related item properties
                expect(Array(filmBeingTested.characterURLs)).to(equal(testFilm.charURLs))
                expect(Array(filmBeingTested.planetURLs)).to(equal(testFilm.planetURLs))
                expect(Array(filmBeingTested.starshipURLs)).to(equal(testFilm.starshipURLs))
                expect(Array(filmBeingTested.vehicleURLs)).to(equal(testFilm.vehicleURLs))
            }
        }
    }
}

// MARK: - Extension for converting Strings to Dates
//Must relocate!
extension String {
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter.date(from: self)
    }
}
