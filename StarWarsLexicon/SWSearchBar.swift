//
//  SWSearchBar.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/30.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class SWSearchBar: UISearchBar {

    var textColor: UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                return textField.textColor
            }
            return nil
        }
        set (newColor) {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                textField.textColor = newColor
            }
        }
    }
    
    override func awakeFromNib() {
        self.keyboardAppearance = .dark
        self.returnKeyType = .search
        self.showsCancelButton = true
    }
}
