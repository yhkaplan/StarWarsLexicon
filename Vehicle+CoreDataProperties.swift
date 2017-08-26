//
//  Vehicle+CoreDataProperties.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/26.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var category: String
    @NSManaged public var costInCredits: Double
    @NSManaged public var itemName: String
    @NSManaged public var itemURL: String
    @NSManaged public var length: Double
    @NSManaged public var manufacturer: String
    @NSManaged public var maximumAtmosphericSpeed: Double
    @NSManaged public var model: String
    @NSManaged public var name: String
    @NSManaged public var numberOfCrewMembers: Int64
    @NSManaged public var numberOfPassengers: Int64
    @NSManaged public var vehicleClass: String
    @NSManaged public var toFilm: NSSet?

}

// MARK: Generated accessors for toFilm
extension Vehicle {

    @objc(addToFilmObject:)
    @NSManaged public func addToToFilm(_ value: Film)

    @objc(removeToFilmObject:)
    @NSManaged public func removeFromToFilm(_ value: Film)

    @objc(addToFilm:)
    @NSManaged public func addToToFilm(_ values: NSSet)

    @objc(removeToFilm:)
    @NSManaged public func removeFromToFilm(_ values: NSSet)

}
