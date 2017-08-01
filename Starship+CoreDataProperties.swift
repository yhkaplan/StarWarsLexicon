//
//  Starship+CoreDataProperties.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/01.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import CoreData


extension Starship {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Starship> {
        return NSFetchRequest<Starship>(entityName: "Starship")
    }

    @NSManaged public var category: String
    @NSManaged public var costInCredits: Double
    @NSManaged public var hyperdriveRating: Double
    @NSManaged public var itemName: String
    @NSManaged public var itemURL: String
    @NSManaged public var length: Double
    @NSManaged public var manufacturer: String
    @NSManaged public var maxAtmosphericSpeed: Double
    @NSManaged public var model: String
    @NSManaged public var name: String
    @NSManaged public var numberOfCrewMembers: Double
    @NSManaged public var numberOfPassengers: Double
    @NSManaged public var starshipClass: String

}
