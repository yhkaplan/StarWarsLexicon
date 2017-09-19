//
//  KeyboardDismisser.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/08/30.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardUponTouch() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        //This prevents gesture recognizer from infering with cells
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
