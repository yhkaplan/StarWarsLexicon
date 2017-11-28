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
            let mockNWService = MockNetworkingService()
            self.filmVM = FilmViewModel(nwService: mockNWService)
        }
        afterEach {
            self.filmVM = nil
        }
        
        describe("Testing Film View Model") {
            context("When getNextPageOfFilms is called") {
                it("it returns the next array of film objects and a nil nextPage URL") {
                    let disposeBag = DisposeBag()
                    
                    self.filmVM?.getNextPageOfFilms()
                        .subscribe(onNext: { films in
                            expect(films.count).to(equal(7))
                            expect(films[0].title).to(equal("A New Hope"))
                        }, onError: { error in
                            fail("Error: \(error)")
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
    }
    
    class MockNetworkingService: NetworkingService {
        enum MockError: Error {
            case MockError(description: String)
        }
        
        override func fetchItemsAndNextPage(at url: URL, for category: SWAPICategory) -> Observable<FilmList> {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            guard let path = Bundle(for: type(of: self)).path(forResource: "TestFilmList", ofType: "json") else {
                return Observable.create { observer in
                    observer.onError(MockError.MockError(description: "Issue creating test data"))
                    return Disposables.create()
                }
            }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let testFilmList = try decoder.decode(FilmList.self, from: data)
                
                return Observable.create { observer in
                    observer.onNext(testFilmList)
                    observer.onCompleted()
                    return Disposables.create()
                }
            } catch let error {
                return Observable.create { observer in
                    observer.onError(MockError.MockError(description: "Mock Error: \(error)"))
                    return Disposables.create()
                }
            }
        }
    }
}
