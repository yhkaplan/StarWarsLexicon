//
//  SWCategory.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/09.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation
import CoreData

@objc protocol SWCategory {
    var category: String { get }
    var itemName: String { get }
    //var itemURL: URL { get }
}

//extension SWCategory where Self: NSManagedObject {
//    let fetchRequest: NSFetchRequest<Self> = NSFetchRequest(entityName: Self.entity().name!)
//    
//    
//}

//Cannot currently get protocol to conform to equatable
//func ==<T: SWCategory>(lhs: T, rhs: T) -> Bool {
//    return lhs.itemURL == rhs.itemURL
//}
