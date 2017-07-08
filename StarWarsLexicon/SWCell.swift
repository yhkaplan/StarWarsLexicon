//
//  SWCell.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/03.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class SWCell: UICollectionViewCell {
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var swItem: SWCategory!
    
    func configureCell<T: SWCategory> (_ swObject: T) {
        textLbl.text = swObject.itemName//TO change later
    }
    
}
