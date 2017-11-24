//
//  RealmFilm.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/11/24.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import RealmSwift

//Make this conform to Decodable and test w/ a JSON file
class RealmFilm: Object {
    @objc dynamic var title = ""
    @objc dynamic var itemURL = ""
    @objc dynamic var director = ""
    
    convenience init(title: String, itemURL: String, director: String) {
        self.init()
        self.title = title
        self.itemURL = itemURL
        self.director = director
    }
}

