//
//  RealmDBManager.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/12/01.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDBManager {
    private let realm: Realm!
    
    private enum DBError: Error {
        case noItemsFound
    }
    
    public enum DBResult {
        case success(Results<RealmFilm>?)
        case failure(Error)
    }
    
    convenience init() {
        do {
            let realm = try Realm()
            self.init(realm: realm)
        } catch let error {
            fatalError("Fatal Error: \(error.localizedDescription)")
        }
    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func get(all items: SWAPICategory) -> DBResult {
        let results = realm.objects(RealmFilm.self)
        return results.count > 0 ? DBResult.success(results) : DBResult.failure(DBError.noItemsFound)
    }
    
    @discardableResult
    func save(_ items: [RealmFilm]) -> DBResult {
        do {
            //Check for copies first
            try realm.write {
                realm.add(items)
            }
            return DBResult.success(nil)
            
        } catch let error {
            return DBResult.failure(error)
        }
    }
}
