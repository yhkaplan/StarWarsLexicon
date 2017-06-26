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
    
    var swItem: SWCategory!
    
    func configureCell<T: SWCategory> (_ swObject: T) {
        //make this accept a generic, then respond with switch to determine the type and configure appropriately
        
        
        //self.swItem = swObject
        
        
        //Switch or if statement to determine type of swobject
        
        //Should this be swObject or a variable stored w/ each cell?
        textLbl.text = swObject.itemName//TO chance later
        
    }
    
}
