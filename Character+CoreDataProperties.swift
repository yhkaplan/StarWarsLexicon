//
//  Character+CoreDataProperties.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/26.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import CoreData


extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var birthYear: String
    @NSManaged public var category: String
    @NSManaged public var eyeColor: String
    @NSManaged public var gender: String
    @NSManaged public var hairColor: String
    @NSManaged public var height: Int16
    @NSManaged public var homeworldURL: String?
    @NSManaged public var itemName: String
    @NSManaged public var itemURL: String
    @NSManaged public var mass: Int32
    @NSManaged public var name: String
    @NSManaged public var skinColor: String
    @NSManaged public var toFilm: NSSet?

}

// MARK: Generated accessors for toFilm
extension Character {

    @objc(addToFilmObject:)
    @NSManaged public func addToToFilm(_ value: Film)

    @objc(removeToFilmObject:)
    @NSManaged public func removeFromToFilm(_ value: Film)

    @objc(addToFilm:)
    @NSManaged public func addToToFilm(_ values: NSSet)

    @objc(removeToFilm:)
    @NSManaged public func removeFromToFilm(_ values: NSSet)

}
