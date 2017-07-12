//
//  SWCategory.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/05/09.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import Foundation

protocol SWCategory {
    var category: Category { get }
    var itemName: String { get }
    var itemURL: URL { get }
}
