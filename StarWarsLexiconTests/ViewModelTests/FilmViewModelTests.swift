//
//  FilmViewModelTests.swift
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

class FilmModelViewTests: QuickSpec {
    var filmVM: FilmViewModel?
    
    override func spec() {
        beforeEach {
            let nwService = MockNetworkingService() //Mock the NW service!!
            self.filmVM = FilmViewModel(nwService: nwService)
        }
        afterEach {
            self.filmVM = nil
        }
        
        describe("Testing Film View Model") {
            context("When getNextPageOfFilms is called") {
                it("it returns the next array of film objects and a nil nextPage URL") {
                    //
                }
            }
        }
    }
    
    class MockNetworkingService: NetworkingService {
        override func fetchItemsAndNextPage(at url: URL, for category: SWAPICategory) -> Observable<FilmList> {
            //Use encodable to make some Film objects?
        }
    }
}
