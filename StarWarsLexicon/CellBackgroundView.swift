//
//  CellBackgroundView.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/27.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CellBackgroundView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        clipsToBounds = true

        self.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    }
}
