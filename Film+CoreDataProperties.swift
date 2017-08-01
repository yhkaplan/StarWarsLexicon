//
//  Film+CoreDataProperties.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/01.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var category: String
    @NSManaged public var director: String
    @NSManaged public var episodeID: Int16
    @NSManaged public var itemName: String
    @NSManaged public var itemURL: String
    @NSManaged public var openingCrawl: String
    @NSManaged public var producer: String
    @NSManaged public var releaseDate: NSDate
    @NSManaged public var title: String

}
