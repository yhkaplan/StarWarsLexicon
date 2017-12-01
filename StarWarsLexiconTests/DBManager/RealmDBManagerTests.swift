//
//  RealmDBManagerTests.swift
//  StarWarsLexiconTests
//
//  Created by Joshua Kaplan on 2017/12/01.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import XCTest
import RealmSwift
import Quick
import Nimble

@testable import StarWarsLexicon

class RealmDBManagerTests: QuickSpec {
    private var realm: Realm?
    
    override func spec() {
        
        beforeEach {
            //set realm database
            do {
                let realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
                self.realm = realm
            } catch let error {
                fail("Error: \(error)")
            }
        }
        afterEach {
            //purge realm database
            self.realm = nil
        }
        describe("Testing RealmDBManager") {
            context("When an object is saved using save()") {
                it("returns a success case") {
                    guard let realm = self.realm else {
                        fail()
                        return
                    }
                    
                    let film = testFilm.film
                    let dbManager = RealmDBManager(realm: realm)
                    
                    let result = dbManager.save([film])
                    switch result {
                    case .success(let filmArray):
                        if filmArray == nil {
                            //Currently, the spec is to return nil upon success
                            succeed()
                        } else {
                            fail()
                        }
                    case .failure:
                        fail()
                    }
                }
            }
            context("When objects are retreived with get(all)") {
                it("is returned properly") {
                    guard let realm = self.realm else {
                        fail()
                        return
                    }
                    
                    let film = testFilm.film
                    film.title = "Return of the Test"
                    let dbManager = RealmDBManager(realm: realm)
                    
                    dbManager.save([film])
                    
                    let result = dbManager.get(all: .film)
                    
                    switch result {
                    case .success(let films):
                        guard let films = films, let first = films.first else {
                            fail()
                            return
                        }
                        
                        expect(first).to(equal(film))
                        expect(first.title).to(equal("Return of the Test"))
                        
                        //Also check against local store
                        //let localFilm = realm.objects(RealmFilm.self)
                    case .failure:
                        fail()
                    }
                    
                }
            }
        }
    }
}
