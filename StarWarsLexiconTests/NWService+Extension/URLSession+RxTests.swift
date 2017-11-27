//
//  URLSession+RxTests.swift
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

class URLSessionRxExtensionTests: QuickSpec {
    private let request = URLRequest(url: URL(string: "https://swapi.co/api/films/1/")!)
    private let errorRequest = URLRequest(url: URL(string: "https://google.com/")!)
    
    override func spec() {
        describe("Testing URLSession + Rx Extension") {
            context("When a film object is requested,") {
                it("it should return viable data which can then be compared to json") {
                    
                    //Get NW data using URLSession
                    let observable = URLSession.shared.rx.data(request: self.request)
                    
                    //Prepare local test data
                    guard let path = Bundle(for: type(of: self)).path(forResource: "TestFilm", ofType: "json") else {
                        fail("JSON file could not be loaded")
                        return
                    }
                    
                    //JSON decoder
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    do {
                        let localTestData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        //Change the below to use dictionaries instead of object
                        let localFilmDict = try JSONSerialization.jsonObject(with: localTestData, options: []) as! [String: Any]
                        let localFilm = try decoder.decode(RealmFilm.self, from: localTestData)
                        
                        let resultRetreived = try observable.toBlocking().first()
                        let remoteFilmDict = try JSONSerialization.jsonObject(with: resultRetreived!, options: []) as! [String: Any]
                        let remoteFilm = try decoder.decode(RealmFilm.self, from: resultRetreived!)
                        
                        //Compare dictionaries
                        //Warning, this may fail if the remote version has a new updatedDate entry
                        //Also, theoretically, the arrays have to be sorted 
                        //Compare all dict keys
                        expect(localFilmDict.keys).to(equal(remoteFilmDict.keys))
                        
                        //Compare all dict values (by turning them to strings)
                        let localValueStrings = localFilmDict.values.map { return "\($0)" }
                        let remoteValueStrings = remoteFilmDict.values.map { return "\($0)" }
                        expect(localValueStrings).to(equal(remoteValueStrings))
                        
                        //Compare Film objects: Warning, this depends on the Film object working properly
                        expect(localFilm.title).to(equal(remoteFilm.title))
                    } catch let error {
                        fail("Test failed with following error: \(error)")
                    }
                }
            }
        }
    }
}
