//
//  Film+CoreDataProperties.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/26.
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
    @NSManaged public var toCharacter: NSSet?
    @NSManaged public var toPlanet: NSSet?
    @NSManaged public var toStarship: NSSet?
    @NSManaged public var toVehicle: NSSet?

}

// MARK: Generated accessors for toCharacter
extension Film {

    @objc(addToCharacterObject:)
    @NSManaged public func addToToCharacter(_ value: Character)

    @objc(removeToCharacterObject:)
    @NSManaged public func removeFromToCharacter(_ value: Character)

    @objc(addToCharacter:)
    @NSManaged public func addToToCharacter(_ values: NSSet)

    @objc(removeToCharacter:)
    @NSManaged public func removeFromToCharacter(_ values: NSSet)

}

// MARK: Generated accessors for toPlanet
extension Film {

    @objc(addToPlanetObject:)
    @NSManaged public func addToToPlanet(_ value: Planet)

    @objc(removeToPlanetObject:)
    @NSManaged public func removeFromToPlanet(_ value: Planet)

    @objc(addToPlanet:)
    @NSManaged public func addToToPlanet(_ values: NSSet)

    @objc(removeToPlanet:)
    @NSManaged public func removeFromToPlanet(_ values: NSSet)

}

// MARK: Generated accessors for toStarship
extension Film {

    @objc(addToStarshipObject:)
    @NSManaged public func addToToStarship(_ value: Starship)

    @objc(removeToStarshipObject:)
    @NSManaged public func removeFromToStarship(_ value: Starship)

    @objc(addToStarship:)
    @NSManaged public func addToToStarship(_ values: NSSet)

    @objc(removeToStarship:)
    @NSManaged public func removeFromToStarship(_ values: NSSet)

}

// MARK: Generated accessors for toVehicle
extension Film {

    @objc(addToVehicleObject:)
    @NSManaged public func addToToVehicle(_ value: Vehicle)

    @objc(removeToVehicleObject:)
    @NSManaged public func removeFromToVehicle(_ value: Vehicle)

    @objc(addToVehicle:)
    @NSManaged public func addToToVehicle(_ values: NSSet)

    @objc(removeToVehicle:)
    @NSManaged public func removeFromToVehicle(_ values: NSSet)

}
