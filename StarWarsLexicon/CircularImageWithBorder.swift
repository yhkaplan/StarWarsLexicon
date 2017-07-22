//
//  CircularImageWithBorder.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/07/22.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class CircularImageWithBorder: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        
        layer.borderColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0).cgColor
        layer.borderWidth = 4.0
    }
}
