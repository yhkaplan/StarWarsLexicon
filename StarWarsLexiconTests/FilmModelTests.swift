//
//  FilmModelTests.swift
//  StarWarsLexiconTests
//
//  Created by Joshua Kaplan on 2017/11/24.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import XCTest
import Realm
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
                    let title = "Return of the Jedi"
                    let itemURL = "http://www.WWDC"
                    let director = "George Lucas"
                    
                    let testFilm = RealmFilm(title: title, itemURL: itemURL, director: director)
                    
                    expect(testFilm.director).to(equal(director))
                    expect(testFilm.itemURL).to(equal(itemURL))
                    expect(testFilm.title).to(equal(title))
                }
            }
        }
    }
}

