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
    var itemURL: String { get }
}

//A protocol to provide generic access inside of DataService to each supporting SW Service data model
protocol SWService {
}
