//
//  NWServiceTests.swift
//  StarWarsLexiconTests
//
//  Created by Joshua Kaplan on 2017/11/27.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import XCTest
import RealmSwift
import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import StarWarsLexicon

class NetworkingServiceTests: QuickSpec {
    override func spec() {
        describe("Testing NetworkingService (aka API+Networking service)") {
            context("When the first page of Films is requested") {
                it("returns an array of Film objects and nil for next page") {
                    let url = URL(string: "https://swapi.co/api/films/")!
                    let nwService = NetworkingService()
                    let filmListObservable = nwService.fetchItemsAndNextPage(at: url, for: .film)
                    
                    do {
                        guard let filmList = try filmListObservable.toBlocking().first() else {
                            fail("Could not make filmList object")
                            return
                        }
                        
                        //Tests for nil value in page
                        expect(filmList.nextPage).to(beNil())
                        
                        //Tests for film array values
                        //The first film on the page happens to be "A New Hope"
                        expect(filmList.films[0].title).to(equal("A New Hope"))
                    } catch let error {
                        fail("Test failed with following error: \(error)")
                    }
                }
            }
        }
        
    }
}
