//
//  Planet+CoreDataProperties.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/26.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import CoreData


extension Planet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Planet> {
        return NSFetchRequest<Planet>(entityName: "Planet")
    }

    @NSManaged public var category: String
    @NSManaged public var climate: String
    @NSManaged public var diameter: Double
    @NSManaged public var gravity: Double
    @NSManaged public var itemName: String
    @NSManaged public var itemURL: String
    @NSManaged public var name: String
    @NSManaged public var orbitalPeriod: Int16
    @NSManaged public var population: Double
    @NSManaged public var rotationPeriod: Double
    @NSManaged public var surfaceWater: Double
    @NSManaged public var terrain: String
    @NSManaged public var toFilm: NSSet?

}

// MARK: Generated accessors for toFilm
extension Planet {

    @objc(addToFilmObject:)
    @NSManaged public func addToToFilm(_ value: Film)

    @objc(removeToFilmObject:)
    @NSManaged public func removeFromToFilm(_ value: Film)

    @objc(addToFilm:)
    @NSManaged public func addToToFilm(_ values: NSSet)

    @objc(removeToFilm:)
    @NSManaged public func removeFromToFilm(_ values: NSSet)

}
