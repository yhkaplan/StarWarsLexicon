//
//  StarshipCell.swift
//  StarWarsLexicon
//
//  Created by Joshua Kaplan on 2017/06/28.
//  Copyright © 2017年 Joshua Kaplan. All rights reserved.
//

import UIKit

class StarshipCell: UICollectionViewCell {
    
    @IBOutlet weak var textLbl: UILabel!
    //@IBOutlet weak var cellView: UITableViewCellContentView!
    
    func configureCell<T: SWCategory> (_ swObject: T) {
        textLbl.text = swObject.itemName
    }
}
